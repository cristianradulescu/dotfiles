#!/usr/bin/env bash

# FZF - Command-line fuzzy finder

PACKAGE_NAME="FZF"

fzf_is_installed() {
  command -v fzf >/dev/null 2>&1
}

fzf_get_installed_version() {
  if fzf_is_installed; then
    fzf --version | awk '{print $1}'
  fi
}

fzf_get_latest_version() {
  curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" | grep -Po '"tag_name": "v?\K[^"]*'
}

fzf_install() {
  local VERSION="${1:-$(fzf_get_latest_version)}"
  
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  
  cd /tmp
  curl -sLo fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${VERSION}/fzf-${VERSION}-linux_amd64.tar.gz"
  tar xf fzf.tar.gz fzf
  sudo install fzf /usr/local/bin
  rm -rf fzf fzf.tar.gz
  cd - >/dev/null
  
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    INSTALLED=$(fzf_get_installed_version)
    LATEST=$(fzf_get_latest_version)
    
    if [ -z "$INSTALLED" ]; then
      echo "$PACKAGE_NAME is not installed"
      fzf_install "$LATEST"
    elif [ "$INSTALLED" != "$LATEST" ]; then
      echo "Updating $PACKAGE_NAME: $INSTALLED → $LATEST"
      fzf_install "$LATEST"
    else
      echo "✓ $PACKAGE_NAME is up to date ($INSTALLED)"
    fi
  else
    # When sourced (for initial install)
    fzf_install
  fi
}

main "$@"
