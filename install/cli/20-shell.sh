#!/usr/bin/env bash

# ZSH and Oh-My-Zsh setup

PACKAGE_NAME="ZSH Shell"

shell_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Install ZSH and plugins
  sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting autojump
  
  # Set ZSH as default shell (use sudo to avoid password prompt)
  sudo chsh -s $(which zsh) $USER
  
  # Link .zshrc
  ln -sf ~/dotfiles/.zshrc ~/.zshrc
  
  # Install Oh-my-zsh
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

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v zsh >/dev/null 2>&1; then
      echo "✓ ZSH is already installed"
      echo "ZSH and plugins are managed by Ubuntu's apt"
    else
      shell_install
    fi
  else
    # When sourced (for initial install)
    shell_install
  fi
}

main "$@"
