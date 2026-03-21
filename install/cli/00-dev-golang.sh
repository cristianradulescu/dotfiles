#!/usr/bin/env bash

# Go development environment

PACKAGE_NAME="Golang"

golang_install() {
  echo "Installing $PACKAGE_NAME..."
  sudo apt install -y golang-go delve gopls
  echo "✓ $PACKAGE_NAME installed successfully"
}

golang_update() {
  if is_installed go; then
    echo "Golang is managed by Ubuntu's apt"
  else
    echo "Golang is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) golang_install ;;
    update)  golang_update ;;
  esac
}

main "$@"
