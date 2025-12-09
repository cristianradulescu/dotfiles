#!/usr/bin/env bash

# Solaar - Logitech Unifying Receiver manager

PACKAGE_NAME="Solaar"

solaar_install() {
  echo "Installing $PACKAGE_NAME..."
  
  sudo apt install -y solaar
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v solaar >/dev/null 2>&1; then
      echo "✓ Solaar is already installed"
      echo "Solaar is managed by Ubuntu's apt"
    else
      solaar_install
    fi
  else
    # When sourced (for initial install)
    solaar_install
  fi
}

main "$@"
