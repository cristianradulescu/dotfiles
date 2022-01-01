My dotfile setup
================

```
Shell: zsh
Terminal Font: MesloLGS NF 11 
```

Setup
-----
Common tools:
```sh
sudo apt install git curl mc vim tilix lm-sensors
```

Gnome Shell extensions:
```sh
sudo apt install gnome-shell-extensions gnome-shell-extension-weather gnome-shell-extension-sound-device-chooser gnome-shell-extension-system-monitor
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


cp -v dotfiles/.local/share/fonts/* .local/share/fonts/ && fc-cache -rf

ln -s dotfiles/.zshrc .zshrc
ln -s dotfiles/.p10k.zsh .p10k.zsh
```

Gnome Shell setup:
```sh
cp -v dotfiles/.local/share/backgrounds/2021-12-31-15-24-13-mountain_silhouette.jpg .local/share/backgrounds/2021-12-31-15-24-13-mountain_silhouette.jpg

cat dotfiles/dconf/org_gnome.conf | dconf load /org/gnome/
```

Termux setup:
```sh
cd dotfiles

cat dotfiles/dconf/com_gexperts_Tilix.conf | sed "s|placeholder_uuid|$(gsettings get com.gexperts.Tilix.ProfilesList default | sed "s#'##g")|g" | dconf load /com/gexperts/Tilix/
```
