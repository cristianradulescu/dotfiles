#!/usr/bin/env bash

# Alacritty terminal emulator

PACKAGE_NAME="Alacritty"

alacritty_is_installed() {
  command -v alacritty >/dev/null 2>&1
}

alacritty_get_installed_version() {
  if alacritty_is_installed; then
    alacritty --version | awk '{print $2}'
  fi
}

alacritty_get_latest_version() {
  curl -s "https://api.github.com/repos/alacritty/alacritty/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'
}

alacritty_install() {
  local VERSION="${1:-$(alacritty_get_latest_version)}"
  
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  
  # Install build dependencies
  sudo apt install -y cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
  
  # Create Apps directory
  mkdir -p ~/Apps
  
    # Clone and build Alacritty
    if [ -d ~/Apps/alacritty ]; then
      echo "Alacritty source already exists, updating..."
      cd ~/Apps/alacritty
      git fetch --tags
    else
      echo "Cloning Alacritty repository..."
      cd ~/Apps
      git clone https://github.com/alacritty/alacritty.git
      cd alacritty
      git fetch --tags
    fi
    
    # Checkout the specified version
    echo "Checking out version v$VERSION..."
    git checkout "v$VERSION"
  
  # Build Alacritty
  echo "Building Alacritty (this may take a while)..."
  cargo build --release
  
  # Install binary and desktop file
  sudo cp -f target/release/alacritty /usr/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database
  
  # Set as default terminal
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
  sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty
  
  # Link config
  mkdir -p ~/.config/alacritty
  ln -sf ~/dotfiles/.config/alacritty/alacritty.toml ~/.config/alacritty/
  
  cd ~
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    INSTALLED=$(alacritty_get_installed_version)
    LATEST=$(alacritty_get_latest_version)
    
    if [ -z "$INSTALLED" ]; then
      echo "$PACKAGE_NAME is not installed"
      alacritty_install "$LATEST"
    elif [ "$INSTALLED" != "$LATEST" ]; then
      echo "Updating $PACKAGE_NAME: $INSTALLED → $LATEST"
      alacritty_install "$LATEST"
    else
      echo "✓ $PACKAGE_NAME is up to date ($INSTALLED)"
    fi
  else
    # When sourced (for initial install)
    alacritty_install
  fi
}

main "$@"
