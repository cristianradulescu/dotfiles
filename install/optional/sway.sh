#!/usr/bin/env bash

# Sway window manager and related tools

PACKAGE_NAME="Sway WM"

sway_install() {
  echo "Installing $PACKAGE_NAME..."
  
  sudo apt install -y sway swaybg swayidle swaylock \
    waybar fuzzel mako-notifier grim slurp wl-clipboard cliphist brightnessctl

  sudo usermod -aG input,video $USER
  
  mkdir -p ~/.config/sway
  ln -sf ~/dotfiles/.config/sway/config ~/.config/sway/config
  
  mkdir -p ~/.config/swaylock
  ln -sf ~/dotfiles/.config/swaylock/config ~/.config/swaylock/config
  
  mkdir -p ~/.config/waybar
  ln -sf ~/dotfiles/.config/waybar/config.jsonc ~/.config/waybar/config.jsonc
  ln -sf ~/dotfiles/.config/waybar/style.css ~/.config/waybar/style.css
  
  mkdir -p ~/.config/mako
  ln -sf ~/dotfiles/.config/mako/config ~/.config/mako/config
  
  mkdir -p ~/.config/fuzzel
  ln -sf ~/dotfiles/.config/fuzzel/fuzzel.ini ~/.config/fuzzel/fuzzel.ini
  
  mkdir -p ~/.config/systemd/user/
  cat > ~/.config/systemd/user/cliphist.service << 'EOF'
[Unit]
Description=Clipboard history daemon
PartOf=default.target

[Service]
Type=simple
ExecStart=/usr/bin/wl-paste --watch /usr/bin/cliphist store
Restart=on-failure
RestartSec=5
TimeoutStartSec=60

[Install]
WantedBy=default.target
EOF
  
  systemctl --user daemon-reload
  systemctl --user enable cliphist.service
  systemctl --user start cliphist.service
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

sway_update() {
  if is_installed sway; then
    echo "Sway is managed by Ubuntu's apt"
  else
    echo "Sway is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) sway_install ;;
    update)  sway_update ;;
  esac
}

main "$@"
