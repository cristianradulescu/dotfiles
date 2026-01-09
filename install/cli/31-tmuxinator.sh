#!/usr/bin/env bash

# Tmuxinator - Manage complex tmux sessions easily

PACKAGE_NAME="Tmuxinator"

tmuxinator_install() {
  echo "Installing $PACKAGE_NAME..."

  # Install ruby-rubygems
  sudo apt install -y ruby-rubygems

  # Install tmuxinator
  sudo gem install tmuxinator

  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v tmuxinator >/dev/null 2>&1; then
      echo "Updating $PACKAGE_NAME..."
      sudo gem update tmuxinator
      echo "✓ $PACKAGE_NAME updated successfully"
    else
      tmuxinator_install
    fi
  else
    # When sourced (for initial install)
    tmuxinator_install
  fi
}

main "$@"
