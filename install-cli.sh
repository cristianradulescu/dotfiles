#!/usr/bin/env bash

OS_CODENAME=noble

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
  htop \
  xclip \
  ripgrep fd-find tree tldr \
  jq xq \
  unzip \
  php-cli composer \
  apt-file \
  build-essential autoconf make cmake gettext g++ \
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses-dev \
  imagemagick redis-tools sqlite3 libsqlite3-dev libmysqlclient-dev \
  net-tools \
  openjdk-21-jre openjdk-21-jdk

# ###
# FZF (newer version than in Ubuntu repos)
# ###
echo "Installing FZF"
FZF_VERSION=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo fzf.tar.gz "https://github.com/junegunn/fzf/releases/latest/download/fzf-${FZF_VERSION}-linux_amd64.tar.gz"
tar xf fzf.tar.gz fzf
sudo install fzf /usr/local/bin
rm -rf fzf fzf.tar.gz


# #####################
# Programming languages
# #####################
echo "Install NodeJS from nodesource.com to get a more recent version"
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && \
  sudo apt install -y nodejs

echo "Install Golang, Delve and Go Language Server"
sudo apt install -y golang-go delve gopls

echo "Install PHP, Composer, Symfony CLI"
sudo apt install -y php-cli php-xml composer

curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash
sudo apt install -y symfony-cli

echo "Install Rust via rustup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup override set stable
rustup update stable

# Checkout Phpactor locally (using it as PHAR has some issues with locating stubs)
# Have both stable and unstable version (sometimes annoying issues are fixed on master and I can switch)
sudo git clone https://github.com/phpactor/phpactor.git /opt/phpactor
sudo git clone https://github.com/phpactor/phpactor.git /opt/phpactor-unstable
sudo chown -R "$USER:$USER" /opt/phpactor /opt/phpactor-unstable

# Phpactor stable: switch to latest tag (named like: 2024.06.30.0) and install deps
cd /opt/phpactor && \
  PHPACTOR_LAST_RELEASE=$(git tag -l "$(date +%Y).*" --sort -"version:refname" | head -n1) && \
  git checkout "$PHPACTOR_LAST_RELEASE" && \
  composer install --no-dev --optimize-autoloader && \
  cd ~

# Phpactor unstable: install deps
cd /opt/phpactor-unstable && \
  composer install --no-dev --optimize-autoloader && \
  cd ~

ln -s ~/dotfiles/.config/phpactor ~/.config/phpactor


# #################
# PHP Debug Adapter
# #################
echo "Installing PHP Debug Adapter"
cd /opt && \
  sudo git clone https://github.com/xdebug/vscode-php-debug.git && \
  sudo chown -R "$USER:$USER" /opt/vscode-php-debug && \
  cd vscode-php-debug && \
  npm install && npm run build
cd ~


# #########
# Sonarlint
# #########
echo "Installing Sonarlint for PHP"
SONARLINT_VSCODE_EXT_VERSION=$(curl -s "https://api.github.com/repos/SonarSource/sonarlint-vscode/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
curl -Lo sonarlint.zip "https://github.com/SonarSource/sonarlint-vscode/releases/latest/download/sonarlint-vscode-linux-x64-${SONARLINT_VSCODE_EXT_VERSION}.vsix"
sudo mkdir -p /opt/vscode-sonarlint
sudo chown -R "$USER:$USER" /opt/vscode-sonarlint
unzip sonarlint.zip -d /opt/vscode-sonarlint
rm -rf sonarlint.zip


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
  sudo dpkg -i --force-all nvim-linux-"$(uname -i)".deb && \
  cd ~

sudo apt install -y python3-pynvim luarocks
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
mkdir -p ~/.config/lazygit/ && cp ~/dotfiles/.config/lazygit/themes/catppuccin-mocha.yml ~/.config/lazygit/config.yml

# ##########
# Lazydocker
# ##########
echo "Installing lazydocker"
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin
rm -rf lazydocker lazydocker.tar.gz
mkdir -p ~/.config/lazydocker && ln -s ~/dotfiles/.config/lazydocker/config.yml ~/.config/lazydocker/config.yml

# ######
# Docker
# ######

# Add the official Docker repo
sudo install -m 0755 -d /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $OS_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
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


# ###
# ZSH
# ###
sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting autojump && \
  chsh -s $(which zsh) && \
  ln -s ~/dotfiles/.zshrc ~/.zshrc

# Oh-my-zsh
cd /tmp
curl -LO https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && \
sh install.sh --unattended --keep-zshrc --skip-chsh
cd -

