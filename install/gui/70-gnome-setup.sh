#!/usr/bin/env bash

# Gnome desktop environment configuration

PACKAGE_NAME="Gnome Desktop Settings"

gnome_setup() {
  echo "Configuring $PACKAGE_NAME..."
  
  # Only run if GNOME is the current desktop
  if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]]; then
    echo "Skipping Gnome setup - not running Gnome desktop"
    return
  fi
  
  # Theme / Catppuccin style
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
  gsettings set org.gnome.desktop.interface gtk-theme "Yaru-purple-dark"
  gsettings set org.gnome.desktop.interface icon-theme "Yaru-purple"
  
  # Center new windows in the middle of the screen
  gsettings set org.gnome.mutter center-new-windows true
  
  # Reveal week numbers in the Gnome calendar
  gsettings set org.gnome.desktop.calendar show-weekdate true
  
  # Show battery percentage
  gsettings set org.gnome.desktop.interface show-battery-percentage true
  
  # Make it easy to maximize like you can fill left/right
  gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
  
  # Full-screen with title/navigation bar
  gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Shift>F11']"
  
  # Remove '<Super>v' from notification focus, keep only <Super>m
  gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>m']"
  
  # Disable shortcuts which are using Super (I want them for workspace switching)
  for i in {1..9}; do
    gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
  done
  
  # Use Super for workspaces
  for i in {1..9}; do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
  done
  
  # Clear favorite apps
  gsettings set org.gnome.shell favorite-apps "[]"
  
  # Dock (Ubuntu panel) tweaks
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
  gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
  gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
  gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#131313'
  
  # Map Caps_Lock to CTRL (works on Wayland too)
  gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"
  gsettings set org.gnome.desktop.input-sources sources "[('xkb-options', 'us')]"
  
  # Install extension management tools
  sudo apt install -y gnome-tweaks gnome-shell-extension-manager
  pipx install gnome-extensions-cli --system-site-packages

  # Make sure user extensions are enabled
  gsettings set org.gnome.shell disable-user-extensions false
  
  # Turn off default Ubuntu extensions
  gnome-extensions disable ding@rastersoft.com 2>/dev/null || true
  
  # Install new extensions
  echo "Installing Gnome extensions..."
  gext install windowIsReady_Remover@nunofarruca@gmail.com 2>/dev/null || true
  gext install space-bar@luchrioh 2>/dev/null || true
  gext install clipboard-indicator@tudmotu.com 2>/dev/null || true
  
  # Compile gsettings schemas
  if [ -f ~/.local/share/gnome-shell/extensions/space-bar@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml ]; then
    sudo cp ~/.local/share/gnome-shell/extensions/space-bar@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/
  fi
  if [ -f ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas/org.gnome.shell.extensions.clipboard-indicator.gschema.xml ]; then
    sudo cp ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas/org.gnome.shell.extensions.clipboard-indicator.gschema.xml /usr/share/glib-2.0/schemas/
  fi
  sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
  
  # Configure Space Bar
  gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []" 2>/dev/null || true
  
  # Configure Clipboard Indicator
  gsettings set org.gnome.shell.extensions.clipboard-indicator history-size 100 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.clipboard-indicator show-on-startup true 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.clipboard-indicator clear-on-boot false 2>/dev/null || true
  gsettings set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Super>v']" 2>/dev/null || true
  
  echo "✓ $PACKAGE_NAME configured successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Reapplying Gnome settings..."
    gnome_setup
  else
    # When sourced (for initial install)
    gnome_setup
  fi
}

main "$@"
