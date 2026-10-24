#!/usr/bin/env bash
# Statusline: <model icon> model (effort)  |  <session icon> session name  |
#             <clock icon> 5h usage (reset)  |  <cal icon> 7d usage (reset)
#
# Session cost is NOT included: Claude Code's statusline stdin JSON (see the
# schema documented for this command) does not expose a cost/spend-in-session
# field, only rate_limits.{five_hour,seven_day}.used_percentage. Fabricating
# a cost figure would be misleading, so it is left out.
#
# Likewise there is no true "daily" limit in the stdin payload: the closest
# available windows are the 5-hour rolling session limit and the 7-day
# weekly limit, used below as the "daily"/"weekly" figures requested.

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
# The short "tui-cc-NN" name /list-agents shows isn't in the statusline
# stdin payload at all: it lives in ~/.claude/sessions/<pid>.json's "name"
# field, keyed by "sessionId" matching .session_id here. .session_name in
# the stdin payload is the auto-generated conversation *title* instead
# (e.g. "Session info display details"), so it's only a fallback.
session_id=$(echo "$input" | jq -r '.session_id // empty')
registry_name=""
if [ -n "$session_id" ]; then
  registry_name=$(jq -rs --arg sid "$session_id" \
    '[.[] | select(.sessionId == $sid)] | .[0].name // empty' \
    ~/.claude/sessions/*.json 2>/dev/null)
fi
session_name=$(echo "$input" | jq -r '.session_name // empty')

model_icon=''
session_icon=$'\U000F0866'
five_hour_icon='[5h]'
seven_day_icon='[7d]'
reset_icon=$'\U00021BA'
sep=$'\U000F01D9'

model_info="$model"
if [ -n "$effort" ]; then
  model_info="$model_info ($effort)"
fi

session_display="$registry_name"
if [ -z "$session_display" ]; then
  session_display="$session_name"
fi
if [ -z "$session_display" ] && [ -n "$session_id" ]; then
  session_display=${session_id:0:8}
fi

fmt_reset() {
  # epoch seconds -> local Day HH:MM
  local epoch="$1"
  [ -n "$epoch" ] && [ "$epoch" != "null" ] && date -d "@$epoch" +'%a %H:%M' 2>/dev/null
}

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset_epoch=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
five_info=""
if [ -n "$five_pct" ]; then
  five_info=$(printf '%s %.0f%%' "$five_hour_icon" "$five_pct")
  five_reset=$(fmt_reset "$five_reset_epoch")
  [ -n "$five_reset" ] && five_info="$five_info ($reset_icon $five_reset)"
fi

week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset_epoch=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
week_info=""
if [ -n "$week_pct" ]; then
  week_info=$(printf '%s %.0f%%' "$seven_day_icon" "$week_pct")
  week_reset=$(fmt_reset "$week_reset_epoch")
  [ -n "$week_reset" ] && week_info="$week_info ($reset_icon $week_reset)"
fi

out="${model_icon} ${model_info}"
if [ -n "$session_display" ]; then
  out="$out ${sep} ${session_icon} ${session_display}"
fi
if [ -n "$five_info" ]; then
  out="$out ${sep} ${five_info}"
fi
if [ -n "$week_info" ]; then
  out="$out ${sep} ${week_info}"
fi

printf '%b\n' "$out"
