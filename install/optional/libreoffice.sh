#!/usr/bin/env bash

PACKAGE_NAME="LibreOffice"

libreoffice_install() {
  echo "Installing $PACKAGE_NAME..."

  sudo snap remove --purge libreoffice
  sudo apt remove --purge libreoffice

  sudo mkdir -p /etc/apt/preferences.d/
  echo -e "Package: libreoffice*\nPin: release o=Ubuntu\nPin-Priority: -1" | sudo tee /etc/apt/preferences.d/block-libreoffice-snap

  cd /tmp
  LIBREOFFICE_VERSION=26.8.0
  curl -Lo /tmp/libreoffice.tar.gz https://mirrors.hostico.ro/tdf/libreoffice/stable/${LIBREOFFICE_VERSION}/deb/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz
  tar xfp /tmp/libreoffice.tar.gz
  sudo dpkg -i /tmp/LibreOffice_26.8.0.3_Linux_x86-64_deb/DEBS/*.deb
  rm -rf /tmp/libreoffice.tar.gz /tmp/LibreOffice_26.8.0.3_Linux_x86-64_deb

  cd - >/dev/null
  echo "✓ $PACKAGE_NAME installed successfully"
}

main() {
  case "${1:-install}" in
    install) libreoffice_install ;;
    update)  echo "Update not supported" ;;
  esac
}

main "$@"
