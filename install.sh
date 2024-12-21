#!/usr/bin/env bash

# TODO: 
# - Clipboard manager (copyq, clipboard-indicator)

# Exit immediately if a command exits with a non-zero status
set -e
 
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Dotfiles repo not cloned yet!"
  echo "sudo apt install git && git clone https://github.com/cristianradulescu/dotfiles"

  exit 1
fi

HERE=$(pwd)
source "./install-cli.sh"

# switch back to the original directory in case it is changed on previous script
cd "$HERE"
source "./install-gui.sh"
