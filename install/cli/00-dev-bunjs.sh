#!/usr/bin/env bash

# Bun development environment

PACKAGE_NAME="Bun JS"

function bunjs_install() {
  echo "Installing $PACKAGE_NAME..."

  # Install Bun using the official install script
  curl -fsSL https://bun.sh/install | bash

  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v bun >/dev/null 2>&1; then
      echo "$PACKAGE_NAME is already installed"
    else
      bunjs_install
    fi
  else
    # When sourced (for initial install)
    bunjs_install
  fi
}
