#!/usr/bin/env bash

# #####
# Fonts
# #####
echo "Installing fonts"
mkdir -p ~/.local/share/fonts || echo 0
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFont-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNLNerdFont-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/~Hack/Regular/HackNerdFont-Regular.ttf -o ~/.local/share/fonts/HackNerdFont-Regular.ttf
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


# ##########
# Redis GUIs
# ##########
sudo snap install redisinsight another-redis-desktop-manager


# #############
# Gnome desktop
# #############

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

# Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'sh -c -- "flameshot gui"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control>Print'

# Clear favorite apps
gsettings set org.gnome.shell favorite-apps "[]"

# Auto-hide the dock
# gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
# Disable hot-keys 
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false

# Map Caps_Lock to CTRL (works on Wayland too)
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"
gsettings org.gnome.desktop.input-sources sources "[('xkb-options', 'us')]"

# Manage extensions
sudo apt install -y gnome-tweaks gnome-shell-extension-manager pipx
pipx install gnome-extensions-cli --system-site-packages

# Fix path for pipx 
# TODO: make it permanent
PATH=$HOME/.local/bin:$PATH

# Turn off default Ubuntu extensions
gnome-extensions disable ding@rastersoft.com

# Install new extensions
gext install windowIsReady_Remover@nunofarruca@gmail.com

