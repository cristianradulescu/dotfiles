#!/usr/bin/env bash

# LazyDocker - Simple terminal UI for docker commands

PACKAGE_NAME="LazyDocker"

lazydocker_installed_version() {
  is_installed lazydocker && lazydocker --version | awk '{print $3}' | tr -d ','
}

lazydocker_download_install() {
  local VERSION="$1"
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  cd /tmp
  curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${VERSION}/lazydocker_${VERSION}_Linux_x86_64.tar.gz"
  tar xf lazydocker.tar.gz lazydocker
  sudo install lazydocker /usr/local/bin
  rm -rf lazydocker lazydocker.tar.gz
  cd - >/dev/null
  mkdir -p ~/.config/lazydocker
  ln -sf ~/dotfiles/.config/lazydocker/config.yml ~/.config/lazydocker/config.yml
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

lazydocker_install() {
  lazydocker_download_install "$(github_latest jesseduffield/lazydocker)"
}

lazydocker_update() {
  local installed latest
  installed="$(lazydocker_installed_version)"
  latest="$(github_latest jesseduffield/lazydocker)"

  if [ -z "$installed" ]; then
    echo "$PACKAGE_NAME is not installed, skipping"
  elif [ "$installed" != "$latest" ]; then
    echo "Updating $PACKAGE_NAME: $installed → $latest"
    lazydocker_download_install "$latest"
  else
    log_ok "$PACKAGE_NAME is up to date ($installed)"
  fi
}

main() {
  case "${1:-install}" in
    install) lazydocker_install ;;
    update)  lazydocker_update ;;
  esac
}

main "$@"
