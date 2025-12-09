#!/usr/bin/env bash

# Dygma Bazecor - Keyboard configuration tool

PACKAGE_NAME="Dygma Bazecor"

bazecor_is_installed() {
  [ -f ~/Apps/Bazecor.AppImage ]
}

bazecor_get_installed_version() {
  if bazecor_is_installed; then
    # Extract version from filename if possible, otherwise return "installed"
    echo "installed"
  fi
}

bazecor_get_latest_version() {
  curl -s "https://api.github.com/repos/DygmaLab/Bazecor/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'
}

bazecor_install() {
  local VERSION="${1:-$(bazecor_get_latest_version)}"
  
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  
  # Install libfuse2 dependency
  sudo apt install -y libfuse2t64
  
  # Create Apps directory
  mkdir -p ~/Apps
  
  # Download latest Bazecor
  curl -sL "https://github.com/DygmaLab/Bazecor/releases/download/v${VERSION}/Bazecor-${VERSION}-x64.AppImage" -o ~/Apps/Bazecor.AppImage
  chmod +x ~/Apps/Bazecor.AppImage
  
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    LATEST=$(bazecor_get_latest_version)
    
    if bazecor_is_installed; then
      echo "Updating $PACKAGE_NAME to version $LATEST..."
      bazecor_install "$LATEST"
    else
      echo "$PACKAGE_NAME is not installed"
      bazecor_install "$LATEST"
    fi
  else
    # When sourced (for initial install)
    bazecor_install
  fi
}

main "$@"
