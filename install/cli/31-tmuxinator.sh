#!/usr/bin/env bash

# Tmuxinator - Manage complex tmux sessions easily

PACKAGE_NAME="Tmuxinator"

tmuxinator_install() {
  echo "Installing $PACKAGE_NAME..."
  sudo apt install -y ruby-rubygems
  sudo gem install tmuxinator
  echo "✓ $PACKAGE_NAME installed successfully"
}

tmuxinator_update() {
  if is_installed tmuxinator; then
    echo "Updating $PACKAGE_NAME..."
    sudo gem update tmuxinator
    echo "✓ $PACKAGE_NAME updated successfully"
  else
    echo "Tmuxinator is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) tmuxinator_install ;;
    update)  tmuxinator_update ;;
  esac
}

main "$@"
