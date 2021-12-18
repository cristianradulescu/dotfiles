My dotfile setup
================

```
Shell: zsh
Terminal Font: MesloLGS NF 11 
```

Setup
-----
Dotfiles
git clone https://github.com/cristianradulescu/dotfiles

Zsh
```sh
sudo apt install zsh zsh-syntax-highlighting zsh-autosuggestions autojump

chsh -s /bin/zsh
```

Powerlevel10k
```sh
touch "$HOME/.cache/zshhistory"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc

ln -s dotfiles/.zshrc .zshrc
ln -s dotfiles/.p10k.zsh .p10k.zsh
```
