#!/usr/bin/env bash

# TODO: 
# - Clipboard manager (copyq, clipboard-indicator)

# Exit immediately if a command exits with a non-zero status
set -e
 
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Dotfiles repo not cloned yet!"
  echo "sudo apt install git && git clone https://github.com/cristianradulescu/dotfiles"

  exit 1
fi


# #########
# Setup Git
# #########
cp ~/dotfiles/.gitignore.template ~/.gitignore
cp ~/dotfiles/.gitconfig.template ~/.gitconfig

echo ""
echo "#################"
echo "# Configure Git: "
echo "#################"

read -p "Git email: " -e GIT_EMAIL < /dev/tty && \
  sed s/"email ="/"email = $GIT_EMAIL"/g -i ~/.gitconfig

read -p "Git name: " -e GIT_NAME < /dev/tty && \
sed s/"name ="/"name = $GIT_NAME"/ -i ~/.gitconfig


# #####
# Setup
# #####
echo "Updating list of packages"
sudo apt update

echo "Cleaning up the system"
sudo apt remove -y --purge \
  brltty \
  xserver-xorg-input-wacom


# ##########
# Base tools
# ##########
echo "Installing base tools (file management, build)"
sudo apt install -y \
  curl \
  mc ranger \
  xclip \
  fzf ripgrep fd-find tree tldr \
  unzip \
  php-cli composer \
  flameshot \
  apt-file \
  build-essentials autoconf make gettext g++ \
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
  libvips imagemagick libmagickwand-dev gir1.2-gtop-2.0 gir1.2-clutter-1.0 \
  redis-tools sqlite3 libsqlite3-dev libmysqlclient-dev


# #####################
# Programming languages
# #####################
echo "Install NodeJS from nodesource.com to get a more recent version"
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - && \
  sudo apt install -y nodejs

echo "Install PHP, Composer, Symfony CLI"
sudo apt install -y php-cli php-xml composer

curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash
sudo apt install -y symfony-cli

# Setup Phpactor locally
sudo git clone https://github.com/phpactor/phpactor.git /opt/phpactor && \
  sudo chown -R "$USER:$USER" /opt/phpactor && \
  cd /opt/phpactor && \
  composer install


# ####
# Tmux
# ####
sudo apt install -y tmux
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

echo "Installing tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
  ~/.tmux/plugins/tpm/bin/install_plugins


# ######
# Neovim
# ######
echo "Installing neovim from source (https://github.com/neovim/neovim/blob/master/BUILD.md#quick-start)"
sudo apt remove -y neovim-runtime
ln -s ~/dotfiles/.config/nvim ~/.config/

mkdir -p ~/Apps || echo 0
git clone https://github.com/neovim/neovim ~/Apps/neovim && \
  cd ~/Apps/neovim && \
  git checkout stable && \
  make CMAKE_BUILD_TYPE=RelWithDebInfo && \
  cd build && \
  cpack -G DEB && \
  sudo dpkg -i nvim-linux64.deb && \
  cd ~

sudo apt install -y python3-pynvim 
sudo npm install -g neovim

# #######
# LazyGit
# #######
echo "Installing lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -rf lazygit lazygit.tar.gz


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


# ######
# Docker
# ######

# Add the official Docker repo
sudo install -m 0755 -d /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install Docker engine and standard plugins
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Give this user privileged Docker access
sudo usermod -aG docker ${USER}

# Limit log size to avoid running out of disk
echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json


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

# #####
# Gnome
# #####

# Theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-purple-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-purple"

# Center new windows in the middle of the screen
gsettings set org.gnome.mutter center-new-windows true

# Reveal week numbers in the Gnome calendar
gsettings set org.gnome.desktop.calendar show-weekdate true

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

# Manage extensions
sudo apt install -y gnome-shell-extension-manager pipx
pipx install gnome-extensions-cli --system-site-packages

# Fix path for pipx 
# TODO: make it permanent
PATH=$HOME/.local/bin:$PATH

# Turn off default Ubuntu extensions
gnome-extensions disable ding@rastersoft.com

# Install new extensions
gext install windowIsReady_Remover@nunofarruca@gmail.com

