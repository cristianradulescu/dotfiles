#!/usr/bin/env bash

# Tmux setup

PACKAGE_NAME="Tmux"

tmux_install() {
  echo "Installing $PACKAGE_NAME..."
  
  sudo apt install -y tmux
  ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
  
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins
  fi
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

tmux_update() {
  if is_installed tmux; then
    echo "Tmux is managed by Ubuntu's apt"
  else
    echo "Tmux is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) tmux_install ;;
    update)  tmux_update ;;
  esac
}

main "$@"
