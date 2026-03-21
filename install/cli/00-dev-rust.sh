#!/usr/bin/env bash

# Rust development environment

PACKAGE_NAME="Rust"

rust_install() {
  echo "Installing $PACKAGE_NAME via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  rustup override set stable
  rustup update stable
  echo "✓ $PACKAGE_NAME installed successfully"
}

rust_update() {
  if is_installed rustup; then
    echo "Updating $PACKAGE_NAME..."
    rustup update
    echo "✓ $PACKAGE_NAME updated successfully"
  else
    echo "Rust is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) rust_install ;;
    update)  rust_update ;;
  esac
}

main "$@"
