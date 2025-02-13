#!/usr/bin/env bash

#
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/cristianradulescu/dotfiles/master/install.sh)"
# 

# Exit immediately if a command exits with a non-zero status
set -e

DOTFILES_DIR="$HOME/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  echo "Dotfiles repo already exists in $DOTFILES_DIR"
  exit 1 
fi

sudo apt install git && \
  cd "$HOME" && \
  git clone https://github.com/cristianradulescu/dotfiles && \
  cd "$DOTFILES_DIR"

source "./install-cli.sh"

cd "$DOTFILES_DIR"
echo "Install GUI apps? (y/n)"
read -r response
if [ "$response" = "y" ]; then
  source "./install-gui.sh"
fi

# cd "$DOTFILES_DIR"
# echo "Install udev rules? (y/n)"
# read -r response
# if [ "$response" = "y" ]; then
#   source "./install-udev-rules.sh"
# fi

cd "$DOTFILES_DIR"
echo "Install apparmor profiles? (y/n)"
read -r response
if [ "$response" = "y" ]; then
  source "./install-apparmor-profiles.sh"
fi
