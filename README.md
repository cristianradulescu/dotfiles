My dotfile setup
================

Target OS: Ubuntu

Setup
-----

ZSH + base:

```sh
sudo apt install \
  zsh \
  zsh-syntax-highlighting \
  zsh-autosuggestions \
  autojump \
  git \
  curl \
  mc \
  vim \
  tmux \
  xclip \
  fzf \
  ripgrep \
  fd-find \
  tree

chsh -s /bin/zsh
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

Neovim + LazyVim
Snap version is newer

```sh
sudo snap install neovim

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

git clone https://github.com/LazyVim/starter ~/.config/nvim && rm -rf ~/.config/nvim/.git

ln -s ~/dotfiles/.config/nvim/lua/plugins/init.lua .config/nvim/lua/plugins/init.lua
```
