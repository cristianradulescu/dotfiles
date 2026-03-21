#!/usr/bin/env bash

# Git configuration setup

PACKAGE_NAME="Git Configuration"

git_setup_install() {
  echo "Setting up $PACKAGE_NAME..."
  
  cp ~/dotfiles/.gitignore.template ~/.gitignore
  cp ~/dotfiles/.gitconfig.template ~/.gitconfig
  
  if [ -t 0 ]; then
    echo ""
    echo "#################"
    echo "# Configure Git: "
    echo "#################"
    
    read -p "Git email: " -e GIT_EMAIL < /dev/tty && \
      sed s/"email ="/"email = $GIT_EMAIL"/g -i ~/.gitconfig
    
    read -p "Git name: " -e GIT_NAME < /dev/tty && \
      sed s/"name ="/"name = $GIT_NAME"/ -i ~/.gitconfig
  else
    echo "Non-interactive mode detected - using default Git config"
    sed s/"email ="/"email = test@example.com"/g -i ~/.gitconfig
    sed s/"name ="/"name = Test User"/ -i ~/.gitconfig
  fi
  
  echo "✓ $PACKAGE_NAME configured successfully"
}

git_setup_update() {
  if [ -f ~/.gitconfig ]; then
    echo "✓ Git is already configured"
    echo "Edit ~/.gitconfig manually if you need to update it"
  else
    git_setup_install
  fi
}

main() {
  case "${1:-install}" in
    install) git_setup_install ;;
    update)  git_setup_update ;;
  esac
}

main "$@"
