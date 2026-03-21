#!/usr/bin/env bash

# Bun development environment

PACKAGE_NAME="Bun JS"

bunjs_install() {
  echo "Installing $PACKAGE_NAME..."
  curl -fsSL https://bun.sh/install | bash
  echo "✓ $PACKAGE_NAME installed successfully"
}

bunjs_update() {
  if is_installed bun; then
    echo "Updating $PACKAGE_NAME..."
    bun upgrade
    echo "✓ $PACKAGE_NAME updated successfully"
  else
    echo "Bun is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) bunjs_install ;;
    update)  bunjs_update ;;
  esac
}

main "$@"
