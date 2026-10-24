#!/usr/bin/env bash

# Grabnotate (screenshot and annotation tool for GNOME)

PACKAGE_NAME="Grabnotate"

grabnotate_installed_version() {
  [ -d ~/Apps/grabnotate ] && is_installed grabnotate && git -C ~/Apps/grabnotate describe --tags --exact-match 2>/dev/null | sed 's/^v//'
}

grabnotate_build_install() {
  local VERSION="$1"
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  mkdir -p ~/Apps

  if [ -d ~/Apps/grabnotate ]; then
    git -C ~/Apps/grabnotate fetch --tags
  else
    git clone https://github.com/cristianradulescu/grabnotate.git ~/Apps/grabnotate
  fi

  git -C ~/Apps/grabnotate checkout "v$VERSION"
  # The repo's installer handles apt deps, Rust, build and desktop integration.
  ~/Apps/grabnotate/install.sh

  echo "✓ $PACKAGE_NAME installed successfully"
}

grabnotate_install() {
  grabnotate_build_install "$(github_latest cristianradulescu/grabnotate)"
}

grabnotate_update() {
  local installed latest
  installed="$(grabnotate_installed_version)"
  latest="$(github_latest cristianradulescu/grabnotate)"

  if [ -z "$installed" ]; then
    echo "$PACKAGE_NAME is not installed, skipping"
  elif [ "$installed" != "$latest" ]; then
    echo "Updating $PACKAGE_NAME: $installed → $latest"
    # Shortcuts/autostart/permissions were set on install; skip the prompts
    grabnotate_build_install "$latest" < /dev/null
  else
    log_ok "$PACKAGE_NAME is up to date ($installed)"
  fi
}

main() {
  case "${1:-install}" in
    install) grabnotate_install ;;
    update)  grabnotate_update ;;
  esac
}

main "$@"
