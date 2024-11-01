#!/usr/bin/env bash

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
  build-essential autoconf make gettext g++ \
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses-dev \
  imagemagick redis-tools sqlite3 libsqlite3-dev libmysqlclient-dev


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

# Checkout Phpactor locally (using it as PHAR has some issues with locating stubs)
# Have both stable and unstable version (sometimes annoying issues are fixed on master and I can switch)
sudo git clone https://github.com/phpactor/phpactor.git /opt/phpactor
sudo git clone https://github.com/phpactor/phpactor.git /opt/phpactor-unstable
sudo chown -R "$USER:$USER" /opt/phpactor /opt/phpactor-unstable

# Phpactor stable: switch to latest tag (named like: 2024.06.30.0) and install deps
cd /opt/phpactor && \
  PHPACTOR_LAST_RELEASE=$(git tag -l "$(date +%Y).*" --sort -"version:refname" | head -n1) && \
  git checkout "$PHPACTOR_LAST_RELEASE" && \
  composer install && \
  cd ~

# Phpactor unstable: install deps
cd /opt/phpactor-unstable && \
  composer install && \
  cd ~

# Update check
# Unstable - find if there are new hashes: git fetch && git rev-list HEAD..origin/master | wc -l
# Stable - find last tag:  git tag -l "v*" --sort -"version:refname" | head -n1 


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


#####################
# Arduino IDE, Thonny
#####################
sudo usermod -aG dialout ${USER}

