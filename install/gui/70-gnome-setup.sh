#!/usr/bin/env bash

# Gnome desktop environment configuration

PACKAGE_NAME="Gnome Desktop Settings"

gnome_setup() {
  echo "Configuring $PACKAGE_NAME..."
  
  if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]]; then
    echo "Skipping Gnome setup - not running Gnome desktop"
    return
  fi
  
  # Theme (Catppuccin / Yaru-purple-dark)
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
  gsettings set org.gnome.desktop.interface gtk-theme "Yaru-purple-dark"
  gsettings set org.gnome.desktop.interface icon-theme "Yaru-purple"
  gsettings set org.gnome.desktop.interface accent-color 'purple'
  
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.desktop.calendar show-weekdate true

  # Public holidays in the top bar calendar (re-run at login to roll over years)
  mkdir -p ~/.config/autostart
  cat > ~/.config/autostart/gnome-holidays.desktop <<EOF
[Desktop Entry]
Type=Application
Name=GNOME Holidays
Exec=$HOME/dotfiles/bin/gnome-holidays
NoDisplay=true
X-GNOME-Autostart-enabled=true
EOF
  ~/dotfiles/bin/gnome-holidays || true
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  
  # Keybindings
  gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"
  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
  gsettings set org.gnome.shell.keybindings focus-active-notification "[]"
  gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>n']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"
  
  for i in {1..9}; do
    gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
  done
  
  # Dock
  gsettings set org.gnome.shell favorite-apps "[]"
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
  gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
  gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
  gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#131313'
  
  # Keyboard: Caps Lock → Ctrl
  gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"
  gsettings set org.gnome.desktop.input-sources sources "[('xkb-options', 'us')]"

  # Nautilus file manager
  gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
  gsettings set org.gnome.nautilus.preferences show-hidden-files true
  gsettings set org.gtk.Settings.FileChooser show-hidden true
  gsettings set org.gtk.gtk4.Settings.FileChooser show-hidden true
  
  # Extensions
  sudo apt install -y gnome-tweaks gnome-shell-extension-manager
  pipx install gnome-extensions-cli --system-site-packages
  gsettings set org.gnome.shell disable-user-extensions false
  gnome-extensions disable ding@rastersoft.com 2>/dev/null || true
  gnome-extensions disable tiling-assistant@ubuntu.com 2>/dev/null || true
  gnome-extensions disable web-search-provider@ubuntu.com 2>/dev/null || true
  gnome-extensions disable snapd-search-provider@canonical.com 2>/dev/null || true
  
  echo "Installing Gnome extensions..."
  gext install windowIsReady_Remover@nunofarruca@gmail.com 2>/dev/null || true
  gext install space-bar@luchrioh 2>/dev/null || true
  gext install tactile@lundal.io 2>/dev/null || true
  
  # Compile gsettings schemas
  if [ -f ~/.local/share/gnome-shell/extensions/space-bar@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml ]; then
    sudo cp ~/.local/share/gnome-shell/extensions/space-bar@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/
  fi
  if [ -f ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml ]; then
    sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
  fi

  sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
  
  # Configure Space Bar
  gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []" 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts activate-empty-key "@as []" 2>/dev/null || true
  
  # Configure Tactile
  gsettings set org.gnome.shell.extensions.tactile layout-2-col-2 0 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.tactile layout-2-col-3 0 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.tactile layout-2-row-1 0 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.tactile layout-2-row-2 0 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.tactile layout-3-col-1 3 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.tactile layout-3-col-3 0 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.tactile layout-3-row-1 3 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.tactile gap-size 8 2>/dev/null || true

  echo "✓ $PACKAGE_NAME configured successfully"
}

main() {
  case "${1:-install}" in
    install|update) gnome_setup ;;
  esac
}

main "$@"
