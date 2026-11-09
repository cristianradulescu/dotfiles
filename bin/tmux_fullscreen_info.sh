#!/usr/bin/env bash

# Extra tmux status-right segments (network, bluetooth, battery), printed only while the outer
# terminal is fullscreen - i.e. when GNOME's top bar, which normally shows them, is hidden.
# Each segment prints nothing when it has nothing worth saying.
#
# There's no way to ask GNOME/Wayland whether Alacritty is fullscreen, so infer it from size:
# the terminal grid covers a whole monitor. A maximized window loses GNOME's top bar, which is
# taller than one cell, so it always has at least one row less than a fullscreen one.
#
# Usage (from tmux.conf): tmux_fullscreen_info.sh <cols> <rows> <cell_width_px> <cell_height_px>

cols=$1 rows=$2 cw=$3 ch=$4

# Terminal didn't report its pixel size (e.g. some terminals over ssh) - can't tell, show nothing
[[ $cw =~ ^[1-9][0-9]*$ && $ch =~ ^[1-9][0-9]*$ ]] || exit 0

# Current resolution of every active monitor, one "WIDTH HEIGHT" per line
monitor_sizes() {
  local sizes
  sizes=$(gdbus call --session --dest org.gnome.Mutter.DisplayConfig \
      --object-path /org/gnome/Mutter/DisplayConfig \
      --method org.gnome.Mutter.DisplayConfig.GetCurrentState 2>/dev/null |
    grep -oP "\('[^']+', \K\d+, \d+(?=, [^)]*'is-current': <true>)" | tr -d ,)
  if [ -z "$sizes" ]; then
    # Not GNOME: fall back to the preferred mode of each connected output
    local out
    for out in /sys/class/drm/card*-*; do
      [ "$(cat "$out/status" 2>/dev/null)" = connected ] && head -1 "$out/modes" | tr x ' '
    done
  else
    echo "$sizes"
  fi
}

is_fullscreen() {
  local w h
  while read -r w h; do
    [ -n "$w" ] || continue
    (( cols == w / cw && rows == h / ch )) && return 0
    (( cols == h / cw && rows == w / ch )) && return 0 # monitor rotated to portrait
  done < <(monitor_sizes)
  return 1
}

battery() {
  local bat=
  for b in /sys/class/power_supply/BAT*; do [ -r "$b/capacity" ] && bat=$b && break; done
  [ -n "$bat" ] || return

  local cap status icon extra=
  cap=$(<"$bat/capacity")
  status=$(<"$bat/status")

  # Nerd Font md-battery icons: 10%..90% steps, then full / charging / alert
  local levels=($'\U000F007A' $'\U000F007B' $'\U000F007C' $'\U000F007D' $'\U000F007E'
                $'\U000F007F' $'\U000F0080' $'\U000F0081' $'\U000F0082' $'\U000F0079')
  if [ "$status" = Charging ]; then
    icon=$'\U000F0084'
  elif (( cap <= 15 )); then
    icon=$'\U000F0083'
  else
    local i=$(( (cap + 5) / 10 - 1 ))
    (( i < 0 )) && i=0
    (( i > 9 )) && i=9
    icon=${levels[i]}
  fi

  # Time left while discharging, from energy_now / power_now (µWh / µW)
  if [ "$status" = Discharging ] && [ -r "$bat/energy_now" ] && [ -r "$bat/power_now" ]; then
    local e p
    e=$(<"$bat/energy_now") p=$(<"$bat/power_now")
    if (( p > 0 )); then
      local mins=$(( e * 60 / p ))
      extra=$(printf ' (%d:%02d)' $((mins / 60)) $((mins % 60)))
    fi
  fi

  printf '%s %s%%%s' "$icon" "$cap" "$extra"
}

# Wifi (signal icon + connection name) or ethernet, a VPN icon when one is up, "offline" otherwise
network() {
  local active
  active=$(nmcli -t -f TYPE,NAME,DEVICE connection show --active 2>/dev/null) || return

  # nmcli escapes ':' inside names as '\:' - swap it for a placeholder so splitting on ':' works
  active=${active//\\:/$'\x1f'}

  local type name dev link= vpn=
  while IFS=: read -r type name dev; do
    name=${name//$'\x1f'/:}
    case $type in
      802-11-wireless)
        local q i icons=($'\U000F092F' $'\U000F091F' $'\U000F0922' $'\U000F0925' $'\U000F0928')
        # Link quality out of 70, from the kernel - cheaper than asking nmcli for a scan
        q=$(awk -v d="$dev:" '$1 == d { print int($3) }' /proc/net/wireless)
        i=$(( ${q:-0} * 5 / 71 ))
        (( ${#name} > 20 )) && name="${name:0:19}…"
        [ -z "$link" ] && link="${icons[i]} $name"
        ;;
      802-3-ethernet)
        link=$'\U000F0200'
        ;;
      vpn | wireguard)
        vpn=$' \U000F0582'
        ;;
    esac
  done <<< "$active"

  if [ -z "$link" ]; then
    printf '%s offline' $'\U000F05AA'
    return
  fi

  # Connected, but no internet (captive portal / limited) - NM's last known state, no new check
  local state
  case $(nmcli networking connectivity 2>/dev/null) in
    portal)  state=' (portal)' ;;
    limited) state=' (no internet)' ;;
  esac

  printf '%s%s%s' "$link" "$state" "$vpn"
}

# Connected bluetooth devices (icon + battery when reported); nothing when none are connected
bluetooth() {
  local devices
  devices=$(bluetoothctl devices Connected 2>/dev/null | awk '$1 == "Device" { print $2 }')
  [ -n "$devices" ] || return

  local mac info icon bat out=()
  for mac in $devices; do
    info=$(bluetoothctl info "$mac" 2>/dev/null)
    case $(awk '$1 == "Icon:" { print $2 }' <<< "$info") in
      audio-head*)    icon=$'\U000F02CB' ;;
      audio-*)        icon=$'\U000F04C3' ;;
      input-mouse)    icon=$'\U000F037D' ;;
      input-keyboard) icon=$'\U000F030C' ;;
      input-gaming)   icon=$'\U000F02B4' ;;
      phone)          icon=$'\U000F03F2' ;;
      *)              icon=$'\U000F00B1' ;;
    esac
    # "Battery Percentage: 0x28 (40)"
    bat=$(awk -F'[()]' '/Battery Percentage/ { print $2 }' <<< "$info")
    out+=("$icon${bat:+ $bat%}")
  done
  printf '%s' "${out[*]}"
}

is_fullscreen || exit 0

for segment in network bluetooth battery; do
  text=$($segment)
  [ -n "$text" ] && printf '%s | ' "$text"
done
