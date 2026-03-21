#!/usr/bin/env bash

# ZSH and Oh-My-Zsh setup

PACKAGE_NAME="ZSH Shell"

shell_install() {
  echo "Installing $PACKAGE_NAME..."
  
  sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting autojump
  sudo chsh -s $(which zsh) $USER
  ln -sf ~/dotfiles/.zshrc ~/.zshrc
  
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-my-zsh..."
    cd /tmp
    curl -LO https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    sh install.sh --unattended --keep-zshrc --skip-chsh
    cd - >/dev/null
  fi
  
  echo "✓ $PACKAGE_NAME installed successfully"
  echo "Note: You'll need to log out and back in for shell change to take effect"
}

shell_update() {
  if is_installed zsh; then
    echo "ZSH and plugins are managed by Ubuntu's apt"
  else
    echo "ZSH is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) shell_install ;;
    update)  shell_update ;;
  esac
}

main "$@"
