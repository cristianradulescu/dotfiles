#!/usr/bin/env bash

# Neovim - Modern Vim-based text editor

PACKAGE_NAME="Neovim"

neovim_installed_version() {
  is_installed nvim && nvim --version | head -n1 | awk '{print $2}' | sed 's/^v//'
}

neovim_build_install() {
  local VERSION="$1"
  echo "Installing/Updating $PACKAGE_NAME to version $VERSION..."
  
  sudo apt remove -y neovim-runtime 2>/dev/null || true
  ln -sf ~/dotfiles/.config/nvim ~/.config/
  mkdir -p ~/Apps

  if [ -d ~/Apps/neovim ]; then
    cd ~/Apps/neovim && git fetch --tags
  else
    git clone https://github.com/neovim/neovim ~/Apps/neovim
    cd ~/Apps/neovim && git fetch --tags
  fi

  git checkout "v$VERSION"
  echo "Building Neovim (this may take a while)..."
  make clean
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  cd build
  cpack -G DEB
  sudo dpkg -i --force-all nvim-linux-"$(uname -m)".deb
  cd ~
  
  sudo apt install -y python3-pynvim luarocks
  sudo npm install -g neovim 2>/dev/null || true
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

neovim_install() {
  neovim_build_install "$(github_latest neovim/neovim)"
}

neovim_update() {
  local installed latest
  installed="$(neovim_installed_version)"
  latest="$(github_latest neovim/neovim)"

  if [ -z "$installed" ]; then
    echo "$PACKAGE_NAME is not installed, skipping"
  elif [ "$installed" != "$latest" ]; then
    echo "Updating $PACKAGE_NAME: $installed → $latest"
    neovim_build_install "$latest"
  else
    log_ok "$PACKAGE_NAME is up to date ($installed)"
  fi
}

main() {
  case "${1:-install}" in
    install) neovim_install ;;
    update)  neovim_update ;;
  esac
}

main "$@"
