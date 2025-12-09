#!/usr/bin/env bash

# Node.js development environment

PACKAGE_NAME="Node.js"

nodejs_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Install Node.js from nodesource.com for a more recent version
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install -y nodejs
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

nodejs_update() {
  echo "Updating global Node.js packages..."
  sudo npm update -g
  echo "✓ Global Node.js packages updated"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v node >/dev/null 2>&1; then
      nodejs_update
    else
      echo "$PACKAGE_NAME is not installed"
      nodejs_install
    fi
  else
    # When sourced (for initial install)
    nodejs_install
  fi
}

main "$@"
