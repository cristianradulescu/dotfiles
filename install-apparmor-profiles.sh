#!/usr/bin/env bash


# #############
# Dygma Bazecor
# #############
sudo tee /etc/apparmor.d/bazecor <<EOF
# This profile allows everything and only exists to give the
# application a name instead of having the label "unconfined"

abi <abi/4.0>,
include <tunables/global>

profile bazecor HOME_DIR/Apps/Bazecor.AppImage flags=(unconfined) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/bazecor>
}
EOF

sudo sed -i 's|HOME_DIR|'"$HOME"'|g' /etc/apparmor.d/bazecor
