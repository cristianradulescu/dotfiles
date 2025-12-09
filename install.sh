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

# Install CLI tools
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Starting CLI Installation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
source "./install/cli.sh"

# Install GUI tools (optional)
cd "$DOTFILES_DIR"
echo ""
echo "Install GUI apps? (y/n)"
read -r response
if [ "$response" = "y" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Starting GUI Installation"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  source "./install/gui.sh"
fi

# Install AppArmor profiles (optional)
cd "$DOTFILES_DIR"
echo ""
echo "Install apparmor profiles? (y/n)"
read -r response
if [ "$response" = "y" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Installing AppArmor Profiles"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  source "./install/optional/apparmor.sh"
fi

# Add dotfiles bin to PATH
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
