#!/usr/bin/env bash

# Node.js development environment

PACKAGE_NAME="Node.js"

nodejs_install() {
  echo "Installing $PACKAGE_NAME..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install -y nodejs
  echo "✓ $PACKAGE_NAME installed successfully"
}

nodejs_update() {
  if is_installed node; then
    echo "Updating global Node.js packages..."
    sudo npm update -g
    echo "✓ Global Node.js packages updated"
  else
    echo "Node.js is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) nodejs_install ;;
    update)  nodejs_update ;;
  esac
}

main "$@"
