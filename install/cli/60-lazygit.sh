#!/usr/bin/env bash

# LazyGit - Simple terminal UI for git commands

PACKAGE_NAME="LazyGit"

lazygit_is_installed() {
  command -v lazygit >/dev/null 2>&1
}

lazygit_get_installed_version() {
  if lazygit_is_installed; then
    lazygit --version | tr -s ', ' ' ' | awk '{print $6}' | cut -d"=" -f2
  fi
}

lazygit_get_latest_version() {
  curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'
}

lazygit_install() {
  local VERSION="${1:-$(lazygit_get_latest_version)}"
  
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  
  cd /tmp
  curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -rf lazygit lazygit.tar.gz
  cd - >/dev/null
  
  # Config setup (idempotent)
  mkdir -p ~/.config/lazygit/
  cp ~/dotfiles/.config/lazygit/themes/catppuccin-mocha.yml ~/.config/lazygit/config.yml
  
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    INSTALLED=$(lazygit_get_installed_version)
    LATEST=$(lazygit_get_latest_version)
    
    if [ -z "$INSTALLED" ]; then
      echo "$PACKAGE_NAME is not installed"
      lazygit_install "$LATEST"
    elif [ "$INSTALLED" != "$LATEST" ]; then
      echo "Updating $PACKAGE_NAME: $INSTALLED → $LATEST"
      lazygit_install "$LATEST"
    else
      echo "✓ $PACKAGE_NAME is up to date ($INSTALLED)"
    fi
  else
    # When sourced (for initial install)
    lazygit_install
  fi
}

main "$@"
