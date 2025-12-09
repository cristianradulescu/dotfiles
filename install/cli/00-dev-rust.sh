#!/usr/bin/env bash

# Rust development environment

PACKAGE_NAME="Rust"

rust_install() {
  echo "Installing $PACKAGE_NAME via rustup..."
  
  # Install Rust via rustup
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  
  # Source cargo environment
  source "$HOME/.cargo/env"
  
  # Set stable toolchain
  rustup override set stable
  rustup update stable
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

rust_update() {
  echo "Updating $PACKAGE_NAME..."
  
  if command -v rustup >/dev/null 2>&1; then
    rustup update
    echo "✓ $PACKAGE_NAME updated successfully"
  else
    echo "$PACKAGE_NAME is not installed"
    rust_install
  fi
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    rust_update
  else
    # When sourced (for initial install)
    rust_install
  fi
}

main "$@"
