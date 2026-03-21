#!/usr/bin/env bash

# Quality of life tools setup

PACKAGE_NAME="Quality of life tools"

qoltools_install() {
  echo "Installing $PACKAGE_NAME..."
  pipx install --force tldr-py
  is_installed btop || sudo apt install -y btop
  echo "✓ $PACKAGE_NAME installed successfully"
}

qoltools_update() {
  echo "Updating $PACKAGE_NAME..."
  pipx upgrade tldr-py
  echo "btop is managed by Ubuntu's apt"
  echo "✓ $PACKAGE_NAME updated successfully"
}

main() {
  case "${1:-install}" in
    install) qoltools_install ;;
    update)  qoltools_update ;;
  esac
}

main "$@"
