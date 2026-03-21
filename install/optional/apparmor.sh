#!/usr/bin/env bash

# AppArmor profiles installation

PACKAGE_NAME="AppArmor Profiles"

apparmor_install() {
  echo "Installing $PACKAGE_NAME..."

  # Dygma Bazecor
  echo "Installing Bazecor AppArmor profile..."
  sudo tee /etc/apparmor.d/bazecor <<EOF
# This profile allows everything and only exists to give the
# application a name instead of having the label "unconfined"

abi <abi/4.0>,
include <tunables/global>

profile bazecor $HOME/Apps/Bazecor.AppImage flags=(unconfined) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/bazecor>
}
EOF

  echo "✓ $PACKAGE_NAME installed successfully"
}

main() {
  case "${1:-install}" in
    install|update) apparmor_install ;;
  esac
}

main "$@"
