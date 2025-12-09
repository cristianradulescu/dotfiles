#!/usr/bin/env bash

# Go development environment

PACKAGE_NAME="Golang"

golang_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Install Go, Delve debugger, and Go Language Server
  sudo apt install -y golang-go delve gopls
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v go >/dev/null 2>&1; then
      echo "✓ Golang is already installed"
      echo "Golang is managed by Ubuntu's apt"
    else
      golang_install
    fi
  else
    # When sourced (for initial install)
    golang_install
  fi
}

main "$@"
