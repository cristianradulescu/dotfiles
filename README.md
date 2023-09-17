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

Setup Powerlevel10k
```sh
touch "$HOME/.cache/zshhistory"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

mkdir -p .local/share/fonts/ && cp -v dotfiles/.local/share/fonts/* .local/share/fonts/ && fc-cache -rfv

ln -s dotfiles/.zshrc .zshrc
ln -s dotfiles/.p10k.zsh .p10k.zsh
```

Gnome Shell setup:
```sh
mkdir -p .local/share/backgrounds/ && cp -v dotfiles/.local/share/backgrounds/2021-12-31-15-24-13-mountain_silhouette.jpg .local/share/backgrounds/2021-12-31-15-24-13-mountain_silhouette.jpg

cat dotfiles/dconf/org_gnome.conf | dconf load /org/gnome/
```

Kitty setup:
```sh
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

TMUX
Install plugin manager
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s dotfiles/.tmux.conf .tmux.conf
```

Neovim
Snap version is newer
```sh
sudo snap install neovim
sudo apt install ripgrep
```

!!! Reboot !!!
