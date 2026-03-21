#!/usr/bin/env bash

# Visual Studio Code

PACKAGE_NAME="VS Code"

vscode_install() {
  echo "Installing $PACKAGE_NAME..."
  
  cd /tmp
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  rm -f packages.microsoft.gpg
  cd - >/dev/null
  
  sudo apt update && sudo apt install -y code
  
  mkdir -p ~/.config/Code/User
  ln -sf ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
  ln -sf ~/dotfiles/vscode/keybindings.json ~/.config/Code/User/keybindings.json
  
  echo "Installing VS Code extensions..."
  code --install-extension Catppuccin.catppuccin-vsc
  code --install-extension catppuccin.catppuccin-vsc-icons
  code --install-extension ms-vscode-remote.remote-containers
  code --install-extension ms-azuretools.vscode-docker
  code --install-extension mikestead.dotenv
  code --install-extension xdebug.php-debug
  code --install-extension phpactor.vscode-phpactor
  code --install-extension redhat.vscode-xml
  code --install-extension redhat.vscode-yaml
  code --install-extension mblode.twig-language-2
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

vscode_update() {
  if is_installed code; then
    echo "VS Code is managed by its repository"
  else
    echo "VS Code is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) vscode_install ;;
    update)  vscode_update ;;
  esac
}

main "$@"
