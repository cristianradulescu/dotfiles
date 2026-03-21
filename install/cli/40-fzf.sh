#!/usr/bin/env bash

# FZF - Command-line fuzzy finder

PACKAGE_NAME="FZF"

fzf_installed_version() {
  is_installed fzf && fzf --version | awk '{print $1}'
}

fzf_download_install() {
  local VERSION="$1"
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  cd /tmp
  curl -sLo fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${VERSION}/fzf-${VERSION}-linux_amd64.tar.gz"
  tar xf fzf.tar.gz fzf
  sudo install fzf /usr/local/bin
  rm -rf fzf fzf.tar.gz
  cd - >/dev/null
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

fzf_install() {
  fzf_download_install "$(github_latest junegunn/fzf)"
}

fzf_update() {
  local installed latest
  installed="$(fzf_installed_version)"
  latest="$(github_latest junegunn/fzf)"

  if [ -z "$installed" ]; then
    echo "$PACKAGE_NAME is not installed, skipping"
  elif [ "$installed" != "$latest" ]; then
    echo "Updating $PACKAGE_NAME: $installed → $latest"
    fzf_download_install "$latest"
  else
    log_ok "$PACKAGE_NAME is up to date ($installed)"
  fi
}

main() {
  case "${1:-install}" in
    install) fzf_install ;;
    update)  fzf_update ;;
  esac
}

main "$@"
