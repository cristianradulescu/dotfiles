#!/usr/bin/env bash

# Alacritty terminal emulator

PACKAGE_NAME="Alacritty"

alacritty_installed_version() {
  is_installed alacritty && alacritty --version | awk '{print $2}'
}

alacritty_build_install() {
  local VERSION="$1"
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  
  sudo apt install -y cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
  mkdir -p ~/Apps

  if [ -d ~/Apps/alacritty ]; then
    cd ~/Apps/alacritty && git fetch --tags
  else
    cd ~/Apps && git clone https://github.com/alacritty/alacritty.git && cd alacritty && git fetch --tags
  fi

  git checkout "v$VERSION"
  echo "Building Alacritty (this may take a while)..."
  cargo build --release

  sudo cp -f target/release/alacritty /usr/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
  sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty

  cat > ~/.config/ubuntu-xdg-terminals.list << 'EOF'
Alacritty.desktop
EOF

  mkdir -p ~/.config/alacritty
  ln -sf ~/dotfiles/.config/alacritty/alacritty.toml ~/.config/alacritty/
  cd ~

  echo "✓ $PACKAGE_NAME installed successfully"
}

alacritty_install() {
  alacritty_build_install "$(github_latest alacritty/alacritty)"
}

alacritty_update() {
  local installed latest
  installed="$(alacritty_installed_version)"
  latest="$(github_latest alacritty/alacritty)"

  if [ -z "$installed" ]; then
    echo "$PACKAGE_NAME is not installed, skipping"
  elif [ "$installed" != "$latest" ]; then
    echo "Updating $PACKAGE_NAME: $installed → $latest"
    alacritty_build_install "$latest"
  else
    log_ok "$PACKAGE_NAME is up to date ($installed)"
  fi
}

main() {
  case "${1:-install}" in
    install) alacritty_install ;;
    update)  alacritty_update ;;
  esac
}

main "$@"
