#!/usr/bin/env bash

# Git configuration setup

PACKAGE_NAME="Git Configuration"

git_setup_install() {
  echo "Setting up $PACKAGE_NAME..."
  
  # Copy templates
  cp ~/dotfiles/.gitignore.template ~/.gitignore
  cp ~/dotfiles/.gitconfig.template ~/.gitconfig
  
  # Check if running in interactive terminal
  if [ -t 0 ]; then
    echo ""
    echo "#################"
    echo "# Configure Git: "
    echo "#################"
    
    # Configure email
    read -p "Git email: " -e GIT_EMAIL < /dev/tty && \
      sed s/"email ="/"email = $GIT_EMAIL"/g -i ~/.gitconfig
    
    # Configure name
    read -p "Git name: " -e GIT_NAME < /dev/tty && \
      sed s/"name ="/"name = $GIT_NAME"/ -i ~/.gitconfig
  else
    # Non-interactive mode (e.g., CI/Docker) - use defaults
    echo "Non-interactive mode detected - using default Git config"
    sed s/"email ="/"email = test@example.com"/g -i ~/.gitconfig
    sed s/"name ="/"name = Test User"/ -i ~/.gitconfig
  fi
  
  echo "✓ $PACKAGE_NAME configured successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ -f ~/.gitconfig ]; then
      echo "✓ Git is already configured"
      echo "Edit ~/.gitconfig manually if you need to update it"
    else
      git_setup_install
    fi
  else
    # When sourced (for initial install)
    git_setup_install
  fi
}

main "$@"
