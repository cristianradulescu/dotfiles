#!/usr/bin/env bash

#
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/cristianradulescu/dotfiles/master/install.sh)"
# 

# Exit immediately if a command exits with a non-zero status
set -e

DOTFILES_DIR="$HOME/dotfiles"

# Check if dotfiles already exists
if [ -d "$DOTFILES_DIR" ]; then
  echo "Dotfiles repo already exists in $DOTFILES_DIR"
  exit 1 
fi

# Clone dotfiles repository
sudo apt install git && \
  cd "$HOME" && \
  git clone https://github.com/cristianradulescu/dotfiles && \
  cd "$DOTFILES_DIR"

# ---------------------------------------------------------------------------
# Dev stack selection (asked once, exported for cli.sh to consume)
# ---------------------------------------------------------------------------

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Select dev stacks to install"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Answer y/n for each:"

_ask_stack() {
  local name="$1"
  local var="$2"
  printf "  %-10s [y/N]: " "$name"
  read -r reply < /dev/tty
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    export "$var"=1
  else
    export "$var"=0
  fi
}

_ask_stack "PHP"    INSTALL_STACK_PHP
_ask_stack "Go"     INSTALL_STACK_GO
_ask_stack "NodeJS" INSTALL_STACK_NODEJS
_ask_stack "Rust"   INSTALL_STACK_RUST
_ask_stack "Bun"    INSTALL_STACK_BUN

# ---------------------------------------------------------------------------
# Install CLI tools
# ---------------------------------------------------------------------------

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Starting CLI Installation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
source "$DOTFILES_DIR/install/cli.sh" install

# ---------------------------------------------------------------------------
# Install GUI tools (optional)
# ---------------------------------------------------------------------------

cd "$DOTFILES_DIR"
echo ""
echo "Install GUI apps? (y/n)"
read -r response < /dev/tty
if [ "$response" = "y" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Starting GUI Installation"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  source "$DOTFILES_DIR/install/gui.sh" install
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Add ~/dotfiles/bin to your PATH to use the 'dotfiles' management tool"
echo "Example: export PATH=\"\$HOME/dotfiles/bin:\$PATH\""
echo ""
echo "Usage:"
echo "  dotfiles list             # List all available packages"
echo "  dotfiles update           # Update all packages"
echo "  dotfiles update lazygit   # Update specific package"
echo "  dotfiles install lazygit  # Install/reinstall specific package"
echo ""
