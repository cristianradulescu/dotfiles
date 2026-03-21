#!/usr/bin/env bash

# Google Chrome browser

PACKAGE_NAME="Google Chrome"

chrome_install() {
  echo "Installing $PACKAGE_NAME..."
  cd /tmp
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
  xdg-settings set default-web-browser google-chrome.desktop
  cd - >/dev/null
  echo "✓ $PACKAGE_NAME installed successfully"
}

chrome_update() {
  if is_installed google-chrome; then
    echo "Chrome updates itself automatically"
  else
    echo "Chrome is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) chrome_install ;;
    update)  chrome_update ;;
  esac
}

main "$@"
