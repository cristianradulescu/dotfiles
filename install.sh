#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e
 
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Dotfiles repo not cloned yet!"
  echo "sudo apt install git && git clone https://github.com/cristianradulescu/dotfiles"

  exit 1
fi

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
  vim \
  tmux \
  xclip \
  fzf \
  ripgrep \
  fd-find \
  tree \
  sqlite3 libsqlite3-dev \
  php-cli composer \
  cmake gettext g++\
  python3-pynvim

echo "Install NodeJS from nodesource.com to get a more recent version"
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - && \
  sudo apt install -y nodejs && \
  sudo npm install -g neovim

# #####
# Fonts
# #####
echo "Installing fonts"
mkdir -p ~/.local/share/fonts || echo 0
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFont-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNLNerdFont-Regular.ttf
curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/~Hack/Regular/HackNerdFont-Regular.ttf -o ~/.local/share/fonts/HackNerdFont-Regular.ttf
fc-cache -rfv

# ####
# Tmux
# ####
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

# #######
# LazyGit
# #######
echo "Installing lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -rf lazygit lazygit.tar.gz

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
