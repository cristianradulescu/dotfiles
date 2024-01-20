My dotfile setup
================

```
Shell: zsh
Terminal Font: MesloLGS NF 
```

Setup
-----
Common tools:
```sh
sudo apt install git curl mc vim copyq flameshot xclip
```

ZSH & dependencies:
```sh
sudo apt install zsh zsh-syntax-highlighting zsh-autosuggestions autojump

chsh -s /bin/zsh
```
Clone dotfiles repo:
```sh
git clone https://github.com/cristianradulescu/dotfiles
```

Setup OhMyZsh
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -s dotfiles/.zshrc .zshrc
```

TMUX
Install plugin manager
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s dotfiles/.tmux.conf .tmux.conf
```

Kitty setup:
```sh
# Change theme (if necessary)
kitty +kitten themes --reload-in=all Catppuccin-Mocha

# set as default terminal
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
```

Google Chrome
```sh
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm -v google-chrome-stable_current_amd64.deb
```

CopyQ
```sh
sudo apt install copyq
mkdir -p .config/copyq && cp -rv dotfiles/.config/copyq/* .config/copyq/
```

Neovim
Snap version is newer
```sh
sudo snap install neovim
sudo apt install ripgrep
```

!!! Reboot !!!
