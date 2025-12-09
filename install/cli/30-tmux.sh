#!/usr/bin/env bash

# Tmux setup

PACKAGE_NAME="Tmux"

tmux_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Install tmux
  sudo apt install -y tmux
  
  # Link config
  ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
  
  # Install tmux plugin manager
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins
  fi
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v tmux >/dev/null 2>&1; then
      echo "✓ Tmux is already installed"
      echo "Tmux is managed by Ubuntu's apt"
    else
      tmux_install
    fi
  else
    # When sourced (for initial install)
    tmux_install
  fi
}

main "$@"
