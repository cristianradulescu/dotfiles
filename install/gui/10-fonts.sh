#!/usr/bin/env bash

# Nerd Fonts installation

PACKAGE_NAME="Nerd Fonts"

fonts_install() {
  echo "Installing $PACKAGE_NAME..."
  mkdir -p ~/.local/share/fonts

  sudo apt install -y ttf-mscorefonts-installer

  echo "Downloading JetBrains Mono Nerd Font..."
  curl -sL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf
  curl -sL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNerdFontMono-Regular.ttf
  curl -sL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFont-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNLNerdFont-Regular.ttf
  curl -sL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFontMono-Regular.ttf -o ~/.local/share/fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf

  echo "Downloading Hack Nerd Font..."
  curl -sL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf -o ~/.local/share/fonts/HackNerdFont-Regular.ttf
  curl -sL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Hack/Regular/HackNerdFontMono-Regular.ttf -o ~/.local/share/fonts/HackNerdFontMono-Regular.ttf

  echo "Downloading Ubuntu Mono Nerd Font..."
  curl -sL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFont-Regular.ttf -o ~/.local/share/fonts/UbuntuMonoNerdFont-Regular.ttf
  curl -sL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf -o ~/.local/share/fonts/UbuntuMonoNerdFontMono-Regular.ttf

  fc-cache -rfv
  echo "✓ $PACKAGE_NAME installed successfully"
}

main() {
  case "${1:-install}" in
    install|update) fonts_install ;;
  esac
}

main "$@"
