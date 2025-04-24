#!/usr/bin/env bash

declare -A TIMEZONES

TIMEZONES["RO"]="Europe/Bucharest"

if [ -f $HOME/.zshrc_work ]; then
  TIMEZONES["SW"]="Europe/Zurich"
  TIMEZONES["UTC"]="UTC"
fi

echo -n $(TZ="UTC" date +%Y-%m-%d)" "
for TIMEZONE_COUNTRY in "${!TIMEZONES[@]}"; do
  echo -n "["$(TZ="${TIMEZONES[$TIMEZONE_COUNTRY]}" date +%H:%M)" $TIMEZONE_COUNTRY] "
done
