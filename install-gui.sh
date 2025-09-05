#!/usr/bin/env bash

# #####
# Fonts
# #####
echo "Installing fonts"
mkdir -p ~/.local/share/fonts || echo 0
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNerdFontMono-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFont-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNLNerdFont-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFontMono-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf -o ~/.local/share/fonts/HackNerdFont-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Hack/Regular/HackNerdFontMono-Regular.ttf -o ~/.local/share/fonts/HackNerdFontMono-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFont-Regular.ttf -o ~/.local/share/fonts/UbuntuMonoNerdFont-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf -o ~/.local/share/fonts/UbuntuMonoNerdFontMono-Regular.ttf
fc-cache -rfv


# #######
# Wezterm
# #######
echo "Installing wezterm & set it as default terminal"
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install -y wezterm

mkdir -p ~/.config/wezterm && \
  ln -s ~/dotfiles/.config/wezterm/wezterm.lua ~/.config/wezterm/ && \
  sudo update-alternatives --set x-terminal-emulator /usr/bin/open-wezterm-here


# #########
# Alacritty
# #########
echo "Installing Alacritty (wip)"
# https://github.com/alacritty/alacritty/blob/master/INSTALL.md
mkdir -p ~/.config/alacritty && \
  ln -s ~/dotfiles/.config/alacritty/alacritty.toml ~/.config/alacritty/


# #############
# Google Chrome
# #############

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
xdg-settings set default-web-browser google-chrome.desktop
cd -


# ######
# VsCode
# ######

 cd /tmp
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
rm -f packages.microsoft.gpg
cd -

sudo apt update -y
sudo apt install -y code

mkdir -p ~/.config/Code/User
ln -s ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
ln -s ~/dotfiles/vscode/keybindings.json ~/.config/Code/User/keybindings.json

# Install extensions
code --install-extension Catppuccin.catppuccin-vsc
code --install-extension catppuccin.catppuccin-vsc-icons
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-azuretools.vscode-docker
code --install-extension mikestead.dotenv
code --install-extension xdebug.php-debug
code --install-extension phpactor.vscode-phpactor
code --install-extension redhat.vscode-xml
code --install-extension redhat.vscode-yaml
code --install-extension mblode.twig-language-2
# code --install-extension vscodevim.vim


# #########
# Flameshot
# #########
sudo apt install -y flameshot


# ###################################
# Solaar (Logitech Unifying Receiver)
# ###################################
sudo apt install -y solaar


# #############
# Dygma Bazecor
# #############
sudo apt install -y libfuse2t64
BAZECOR_VERSION=$(curl -s "https://api.github.com/repos/DygmaLab/Bazecor/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -L "https://github.com/DygmaLab/Bazecor/releases/download/v${BAZECOR_VERSION}/Bazecor-${BAZECOR_VERSION}-x64.AppImage" -o ~/Apps/Bazecor.AppImage && \
  chmod +x ~/Apps/Bazecor.AppImage


# ##############
# Autostart apps
# ##############
mkdir -p ~/.config/autostart && \
   cp /usr/share/applications/org.flameshot.Flameshot.desktop ~/.config/autostart


# #############
# Gnome desktop
# #############
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then

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
  gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"

  # Use Super for workspaces
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']"

  # Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Flameshot'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'sh -c -- "flameshot gui"'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding 'Print'

  # Clear favorite apps
  gsettings set org.gnome.shell favorite-apps "[]"

  # Dock (Ubuntu panel) tweaks (auto hide, smaller icons, no hotkeys, match background with top panel)
  # gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
  gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
  gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
  gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#131313'

  # Map Caps_Lock to CTRL (works on Wayland too)
  gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"
  gsettings set org.gnome.desktop.input-sources sources "[('xkb-options', 'us')]"

  # Manage extensions
  sudo apt install -y gnome-tweaks gnome-shell-extension-manager pipx
  pipx install gnome-extensions-cli --system-site-packages

  # Fix path for pipx 
  # TODO: make it permanent
  PATH=$HOME/.local/bin:$PATH

  ### Turn off default Ubuntu extensions
  # Desktop icons
  gnome-extensions disable ding@rastersoft.com
  # Dock
  # gnome-extensions disable ubuntu-dock@ubuntu.com

  ### Install new extensions
  # Remove nagging windows is ready popup
  gext install windowIsReady_Remover@nunofarruca@gmail.com
  # Better workspace indicator
  gext install space-bar@luchrioh
  # Clipboard manager
  gext install clipboard-indicator@tudmotu.com

  # Compile gsettings schemas in order to be able to set them
  sudo cp ~/.local/share/gnome-shell/extensions/space-bar\@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/
  sudo cp ~/.local/share/gnome-shell/extensions/clipboard-indicator\@tudmotu.com/schemas/org.gnome.shell.extensions.clipboard-indicator.gschema.xml /usr/share/glib-2.0/schemas/
  sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

  # Configure Space Bar
  gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

  # Configure Clipboard Indicator
  gsettings set org.gnome.shell.extensions.clipboard-indicator history-size 100
  gsettings set org.gnome.shell.extensions.clipboard-indicator show-on-startup true
  gsettings set org.gnome.shell.extensions.clipboard-indicator clear-on-boot false
  gsettings set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Super>v']"

fi
