#!/usr/bin/env bash

# LazyDocker - Simple terminal UI for docker commands

PACKAGE_NAME="LazyDocker"

lazydocker_is_installed() {
  command -v lazydocker >/dev/null 2>&1
}

lazydocker_get_installed_version() {
  if lazydocker_is_installed; then
    lazydocker --version | awk '{print $3}' | tr -d ','
  fi
}

lazydocker_get_latest_version() {
  curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'
}

lazydocker_install() {
  local VERSION="${1:-$(lazydocker_get_latest_version)}"
  
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  
  cd /tmp
  curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${VERSION}/lazydocker_${VERSION}_Linux_x86_64.tar.gz"
  tar xf lazydocker.tar.gz lazydocker
  sudo install lazydocker /usr/local/bin
  rm -rf lazydocker lazydocker.tar.gz
  cd - >/dev/null
  
  # Config setup (idempotent)
  mkdir -p ~/.config/lazydocker
  ln -sf ~/dotfiles/.config/lazydocker/config.yml ~/.config/lazydocker/config.yml
  
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    INSTALLED=$(lazydocker_get_installed_version)
    LATEST=$(lazydocker_get_latest_version)
    
    if [ -z "$INSTALLED" ]; then
      echo "$PACKAGE_NAME is not installed"
      lazydocker_install "$LATEST"
    elif [ "$INSTALLED" != "$LATEST" ]; then
      echo "Updating $PACKAGE_NAME: $INSTALLED → $LATEST"
      lazydocker_install "$LATEST"
    else
      echo "✓ $PACKAGE_NAME is up to date ($INSTALLED)"
    fi
  else
    # When sourced (for initial install)
    lazydocker_install
  fi
}

main "$@"
