#!/usr/bin/env bash

while true; do
  ssh -v -R 1080 -N -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes my-work-machine
  echo "SSH connection lost. Reconnecting in 5 seconds..."
  sleep 5
done
