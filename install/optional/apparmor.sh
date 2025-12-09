#!/usr/bin/env bash

# AppArmor profiles installation

PACKAGE_NAME="AppArmor Profiles"

apparmor_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Run the install script from the repository
  if [ -f ~/dotfiles/install-apparmor-profiles.sh ]; then
    source ~/dotfiles/install-apparmor-profiles.sh
  else
    echo "Warning: install-apparmor-profiles.sh not found"
  fi
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Reinstalling $PACKAGE_NAME..."
    apparmor_install
  else
    # When sourced (for initial install)
    apparmor_install
  fi
}

main "$@"
