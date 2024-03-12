My dotfile setup
================

Target OS: Ubuntu

Setup
-----

ZSH + base:

```sh
sudo apt install -y \
  zsh zsh-syntax-highlighting zsh-autosuggestions autojump \
  git \
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
  cmake gettext \
  python3-neovim

chsh -s /bin/zsh
```

More recent version for NodeJS
```sh
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - &&\
sudo apt install -y nodejs
sudo npm install -g neovim
```

Dotfiles repo:

```sh
git clone https://github.com/cristianradulescu/dotfiles
```

OhMyZsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -s ~/dotfiles/.zshrc ~/.zshrc
```

TMUX
Install plugin manager

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s ~/dotfiles/.tmux.conf .tmux.conf
```

Neovim 

```sh
NEOVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz"
tar xf nvim-linux64.tar.gz
sudo ln -s ~/nvim-linux64/bin/nvim /usr/local/bin
rm -rf nvim-linux64.tar.gz
```

Neovim nightly

```sh
git clone https://github.com/neovim/neovim.git neovim-nigtly

cd neovim-nightly &&  make CMAKE_BUILD_TYPE=RelWithDebInfo && cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
```

LazyVim

```sh
git clone https://github.com/LazyVim/starter ~/.config/nvim && rm -rf ~/.config/nvim/.git

ln -s ~/dotfiles/.config/nvim-lazyvim/lua/plugins/init.lua .config/nvim/lua/plugins/init.lua
```

Kickstarter-based Nvim

```sh
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
```


LazyGit

```sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -rf lazygit lazygit.tar.gz
```
