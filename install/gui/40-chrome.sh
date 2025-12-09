#!/usr/bin/env bash

# Google Chrome browser

PACKAGE_NAME="Google Chrome"

chrome_install() {
  echo "Installing $PACKAGE_NAME..."
  
  cd /tmp
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
  
  # Set as default browser
  xdg-settings set default-web-browser google-chrome.desktop
  
  cd - >/dev/null
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v google-chrome >/dev/null 2>&1; then
      echo "✓ Google Chrome is already installed"
      echo "Chrome updates itself automatically"
    else
      chrome_install
    fi
  else
    # When sourced (for initial install)
    chrome_install
  fi
}

main "$@"
