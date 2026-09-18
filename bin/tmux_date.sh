#!/usr/bin/env bash

# Ordered list of "LABEL=TZ" entries shown in the tmux status bar
zones=("RO=Europe/Bucharest")

if [ -f "$HOME/.zshrc_work" ]; then
  zones+=("SW=Europe/Zurich" "UTC=UTC")
fi

printf '%s ' "$(TZ=UTC date +%F)"
for z in "${zones[@]}"; do
  printf '[%s %s] ' "$(TZ="${z#*=}" date +%H:%M)" "${z%%=*}"
done
