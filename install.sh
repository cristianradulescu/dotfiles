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

source "./install-cli.sh"
source "./install-gui.sh"
