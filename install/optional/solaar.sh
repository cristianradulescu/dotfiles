#!/usr/bin/env bash

# Solaar - Logitech Unifying Receiver manager

PACKAGE_NAME="Solaar"

solaar_install() {
  echo "Installing $PACKAGE_NAME..."
  sudo apt install -y solaar
  echo "✓ $PACKAGE_NAME installed successfully"
}

solaar_update() {
  if is_installed solaar; then
    echo "Solaar is managed by Ubuntu's apt"
  else
    echo "Solaar is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) solaar_install ;;
    update)  solaar_update ;;
  esac
}

main "$@"
