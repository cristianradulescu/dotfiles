#!/usr/bin/env bash

# Neovim - Modern Vim-based text editor

PACKAGE_NAME="Neovim"

neovim_is_installed() {
  command -v nvim >/dev/null 2>&1
}

neovim_get_installed_version() {
  if neovim_is_installed; then
    nvim --version | head -n1 | awk '{print $2}' | sed 's/^v//'
  fi
}

neovim_get_latest_version() {
  curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'
}

neovim_install() {
  local VERSION="${1:-$(neovim_get_latest_version)}"
  
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  
  # Remove old neovim-runtime if exists
  sudo apt remove -y neovim-runtime 2>/dev/null || true
  
  # Link config
  ln -sf ~/dotfiles/.config/nvim ~/.config/
  
  # Create Apps directory
  mkdir -p ~/Apps
  
    # Clone and build Neovim
    if [ -d ~/Apps/neovim ]; then
      echo "Neovim source already exists, updating..."
      cd ~/Apps/neovim
      git fetch --tags
    else
      echo "Cloning Neovim repository..."
      git clone https://github.com/neovim/neovim ~/Apps/neovim
      cd ~/Apps/neovim
      git fetch --tags
    fi
    
    # Checkout the specified version
    echo "Checking out version v$VERSION..."
    git checkout "v$VERSION"
  
  # Build Neovim
  echo "Building Neovim (this may take a while)..."
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  cd build
  cpack -G DEB
  sudo dpkg -i --force-all nvim-linux-"$(uname -i)".deb
  cd ~
  
  # Install Neovim dependencies
  echo "Installing Neovim language support..."
  sudo apt install -y python3-pynvim luarocks
  sudo npm install -g neovim 2>/dev/null || true
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    INSTALLED=$(neovim_get_installed_version)
    LATEST=$(neovim_get_latest_version)
    
    if [ -z "$INSTALLED" ]; then
      echo "$PACKAGE_NAME is not installed"
      neovim_install "$LATEST"
    elif [ "$INSTALLED" != "$LATEST" ]; then
      echo "Updating $PACKAGE_NAME: $INSTALLED → $LATEST"
      neovim_install "$LATEST"
    else
      echo "✓ $PACKAGE_NAME is up to date ($INSTALLED)"
    fi
  else
    # When sourced (for initial install)
    neovim_install
  fi
}

main "$@"
