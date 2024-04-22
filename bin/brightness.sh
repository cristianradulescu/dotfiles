#!/usr/bin/env bash

PRIMARY_DISPLAY=$(xrandr --current | grep "connected primary" | tee | cut -d" " -f1)
BRIGHTNESS=$(xrandr --verbose | grep -i brightness | cut -d " " -f2)

BRIGHTNESS_ACTION=$1
if [[ "$BRIGHTNESS_ACTION" == "up" ]]; then
  NEW_BRIGHTNESS=$(echo "$BRIGHTNESS" + .1 | bc -l)
else
  NEW_BRIGHTNESS=$(echo "$BRIGHTNESS" - .1 | bc -l)
fi

xrandr --output "$PRIMARY_DISPLAY" --brightness "$NEW_BRIGHTNESS"
