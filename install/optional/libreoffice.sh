#!/usr/bin/env bash

PACKAGE_NAME="LibreOffice"

libreoffice_install() {
  echo "Installing $PACKAGE_NAME..."

  sudo snap remove --purge libreoffice
  sudo apt remove --purge -y 'libreoffice*'

  sudo mkdir -p /etc/apt/preferences.d/
  echo -e "Package: libreoffice*\nPin: release o=Ubuntu\nPin-Priority: -1" | sudo tee /etc/apt/preferences.d/block-libreoffice-snap

  LIBREOFFICE_VERSION=26.8.0
  local tmp
  tmp=$(mktemp -d)
  curl -Lo "$tmp/libreoffice.tar.gz" https://mirrors.hostico.ro/tdf/libreoffice/stable/${LIBREOFFICE_VERSION}/deb/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb.tar.gz
  tar xfp "$tmp/libreoffice.tar.gz" -C "$tmp"
  # Archive unpacks to LibreOffice_<full build version>_Linux_x86-64_deb/
  sudo dpkg -i "$tmp"/LibreOffice_${LIBREOFFICE_VERSION}*_Linux_x86-64_deb/DEBS/*.deb
  rm -rf "$tmp"

  echo "✓ $PACKAGE_NAME installed successfully"
}

main() {
  case "${1:-install}" in
    install) libreoffice_install ;;
    update)  echo "Update not supported" ;;
  esac
}

main "$@"
