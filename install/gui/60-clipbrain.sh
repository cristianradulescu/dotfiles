#!/usr/bin/env bash

# Clipbrain (clipboard history manager for GNOME)

PACKAGE_NAME="Clipbrain"

clipbrain_installed_version() {
  [ -d ~/Apps/clipbrain ] && is_installed clipbrain && git -C ~/Apps/clipbrain describe --tags --exact-match 2>/dev/null | sed 's/^v//'
}

clipbrain_build_install() {
  local VERSION="$1"
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  mkdir -p ~/Apps

  if [ -d ~/Apps/clipbrain ]; then
    git -C ~/Apps/clipbrain fetch --tags
  else
    git clone https://github.com/cristianradulescu/clipbrain.git ~/Apps/clipbrain
  fi

  git -C ~/Apps/clipbrain checkout "v$VERSION"
  # The repo's installer handles apt deps, Rust, build and desktop integration.
  ~/Apps/clipbrain/install.sh

  echo "✓ $PACKAGE_NAME installed successfully"
}

clipbrain_install() {
  clipbrain_build_install "$(github_latest cristianradulescu/clipbrain)"
}

clipbrain_update() {
  local installed latest
  installed="$(clipbrain_installed_version)"
  latest="$(github_latest cristianradulescu/clipbrain)"

  if [ -z "$installed" ]; then
    echo "$PACKAGE_NAME is not installed, skipping"
  elif [ "$installed" != "$latest" ]; then
    echo "Updating $PACKAGE_NAME: $installed → $latest"
    # Shortcuts/autostart/permissions were set on install; skip the prompts
    clipbrain_build_install "$latest" < /dev/null
  else
    log_ok "$PACKAGE_NAME is up to date ($installed)"
  fi
}

main() {
  case "${1:-install}" in
    install) clipbrain_install ;;
    update)  clipbrain_update ;;
  esac
}

main "$@"
