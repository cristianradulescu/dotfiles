#!/usr/bin/env bash

# Dygma Bazecor - Keyboard configuration tool

PACKAGE_NAME="Dygma Bazecor"

bazecor_download_install() {
  local VERSION="$1"
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  sudo apt install -y libfuse2t64
  mkdir -p ~/Apps
  curl -sL "https://github.com/DygmaLab/Bazecor/releases/download/v${VERSION}/Bazecor-${VERSION}-x64.AppImage" \
    -o ~/Apps/Bazecor.AppImage
  chmod +x ~/Apps/Bazecor.AppImage
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

bazecor_install() {
  bazecor_download_install "$(github_latest DygmaLab/Bazecor)"
}

bazecor_update() {
  bazecor_download_install "$(github_latest DygmaLab/Bazecor)"
}

main() {
  case "${1:-install}" in
    install) bazecor_install ;;
    update)  bazecor_update ;;
  esac
}

main "$@"
