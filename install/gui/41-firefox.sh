#!/usr/bin/env bash

PACKAGE_NAME="Firefox"

firefox_install() {
  echo "Installing $PACKAGE_NAME..."

  sudo snap remove --purge firefox
  sudo apt remove --purge firefox

  if [ -f /etc/apt/sources.list.d/mozilla.sources ]; then
    echo "Mozilla apt source already configured, skipping"
  else
    sudo install -d -m 0755 /etc/apt/keyrings
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'

    sudo tee /etc/apt/sources.list.d/mozilla.sources > /dev/null << EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

    sudo tee /etc/apt/preferences.d/mozilla > /dev/null << EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

    sudo tee /etc/apt/preferences.d/mozilla > /dev/null << EOF
Package: firefox
Pin: release o=Ubuntu
Pin-Priority: -1
EOF

    sudo apt update
  fi

  sudo apt install -y firefox

  cd - >/dev/null
  echo "✓ $PACKAGE_NAME installed successfully"
}

firefox_update() {
  if is_installed firefox; then
    echo "Firefox updates itself automatically"
  else
    echo "Firefox is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) firefox_install ;;
    update)  firefox_update ;;
  esac
}

main "$@"
