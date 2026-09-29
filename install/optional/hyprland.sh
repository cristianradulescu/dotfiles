#!/usr/bin/env bash

# Hyprland compositor. Reuses the Sway tool stack (waybar, fuzzel, swaync,
# cliphist), so install the sway package first.

PACKAGE_NAME="Hyprland"

hyprland_install() {
  echo "Installing $PACKAGE_NAME..."

  sudo apt install -y hyprland xdg-desktop-portal-hyprland hyprlock hypridle hyprpaper

  mkdir -p ~/.config/hypr
  ln -sf ~/dotfiles/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
  ln -sf ~/dotfiles/.config/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf
  ln -sf ~/dotfiles/.config/hypr/hypridle.conf ~/.config/hypr/hypridle.conf
  ln -sf ~/dotfiles/.config/hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf

  echo "✓ $PACKAGE_NAME installed successfully"
}

hyprland_update() {
  if is_installed Hyprland; then
    echo "Hyprland is managed by Ubuntu's apt"
  else
    echo "Hyprland is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) hyprland_install ;;
    update)  hyprland_update ;;
  esac
}

main "$@"
