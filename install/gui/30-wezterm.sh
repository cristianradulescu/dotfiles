#!/usr/bin/env bash

# WezTerm terminal emulator

PACKAGE_NAME="WezTerm"

wezterm_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Add WezTerm repository
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  
  # Install WezTerm
  sudo apt update
  sudo apt install -y wezterm
  
  # Link config
  mkdir -p ~/.config/wezterm
  ln -sf ~/dotfiles/.config/wezterm/wezterm.lua ~/.config/wezterm/
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v wezterm >/dev/null 2>&1; then
      echo "✓ WezTerm is already installed"
      echo "WezTerm is managed by its repository"
    else
      wezterm_install
    fi
  else
    # When sourced (for initial install)
    wezterm_install
  fi
}

main "$@"
