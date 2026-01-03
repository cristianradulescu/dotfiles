#!/usr/bin/env bash

# Quality of life tools setup

PACKAGE_NAME="Quality of life tools"

qoltools_install() {
  echo "Installing $PACKAGE_NAME..."

  echo "Installing TLDR..."
  pipx install --force tldr-py

  if ! command -v btop >/dev/null 2>&1; then
    echo "Installing btop..."
    sudo apt install -y btop
  else
    echo "✓ btop is already installed"
  fi

  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Updating $PACKAGE_NAME..."
    qoltools_install
  else
    # When sourced (for initial install)
    qoltools_install
  fi
}

main "$@"
