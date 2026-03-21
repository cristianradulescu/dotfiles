#!/usr/bin/env bash

# LazyGit - Simple terminal UI for git commands

PACKAGE_NAME="LazyGit"

lazygit_installed_version() {
  is_installed lazygit && lazygit --version | tr -s ', ' ' ' | awk '{print $6}' | cut -d"=" -f2
}

lazygit_download_install() {
  local VERSION="$1"
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  cd /tmp
  curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -rf lazygit lazygit.tar.gz
  cd - >/dev/null
  mkdir -p ~/.config/lazygit/
  cp ~/dotfiles/.config/lazygit/themes/catppuccin-mocha.yml ~/.config/lazygit/config.yml
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

lazygit_install() {
  lazygit_download_install "$(github_latest jesseduffield/lazygit)"
}

lazygit_update() {
  local installed latest
  installed="$(lazygit_installed_version)"
  latest="$(github_latest jesseduffield/lazygit)"

  if [ -z "$installed" ]; then
    echo "$PACKAGE_NAME is not installed, skipping"
  elif [ "$installed" != "$latest" ]; then
    echo "Updating $PACKAGE_NAME: $installed → $latest"
    lazygit_download_install "$latest"
  else
    log_ok "$PACKAGE_NAME is up to date ($installed)"
  fi
}

main() {
  case "${1:-install}" in
    install) lazygit_install ;;
    update)  lazygit_update ;;
  esac
}

main "$@"
