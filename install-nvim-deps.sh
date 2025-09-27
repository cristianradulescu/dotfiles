#!/usr/bin/env bash

mkdir -p ~/lsp

# Phpactor
cd ~/lsp
git clone https://github.com/phpactor/phpactor
cd phpactor && composer install --no-dev --optimize-autoloader
ln -s ~/dotfiles/.config/phpactor ~/.config/phpactor

# PHP Debug Adapter
cd ~/lsp
git clone https://github.com/xdebug/vscode-php-debug
cd vscode-php-debug && npm install && npm run build

# Sonarlint
cd ~/lsp
SONARLINT_VSCODE_EXT_VERSION=$(curl -s "https://api.github.com/repos/SonarSource/sonarlint-vscode/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
curl -Lo /tmp/sonarlint.zip "https://github.com/SonarSource/sonarlint-vscode/releases/latest/download/sonarlint-vscode-linux-x64-${SONARLINT_VSCODE_EXT_VERSION}.vsix"
mkdir -p vscode-sonarlint
unzip /tmp/sonarlint.zip -d vscode-sonarlint
rm -rf /tmp/sonarlint.zip


# LuaLS
cd ~/lsp
LUALS_VERSION=$(curl -s "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
curl -Lo /tmp/luals.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/${LUALS_VERSION}/lua-language-server-${LUALS_VERSION}-linux-x64.tar.gz"
mkdir -p lua-language-server
tar xvfp /tmp/luals.tar.gz -C lua-language-server
rm -rf /tmp/luals.tar.gz

# Intelephense
cd ~/lsp
mkdir intelephense && cd intelephense && npm i intelephense

# BashLS
cd ~/lsp
mkdir bashls && cd bashls && npm i bash-language-server

# Twiggy
cd ~/lsp
mkdir twiggy-language-server && cd twiggy-language-server && npm i twiggy-language-server

# Docker compose
cd ~/lsp
mkdir compose-language-service && cd compose-language-service && npm i @microsoft/compose-language-service

# DockerLS
cd ~/lsp
go install github.com/docker/docker-language-server/cmd/docker-language-server@latest

# json, html, css
cd ~/lsp
mkdir vscode-langservers-extracted && cd vscode-langservers-extracted && npm i vscode-langservers-extracted

# yamlls
cd ~/lsp
git clone https://github.com/redhat-developer/yaml-language-server
cd yaml-language-server && npm install && npm run build

# lemminx
cd ~/lsp
LEMMINX_VERSION=$(curl -s "https://api.github.com/repos/redhat-developer/vscode-xml/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
curl -Lo /tmp/lemminx.zip "https://github.com/redhat-developer/vscode-xml/releases/download/${LEMMINX_VERSION}/lemminx-linux.zip"
mkdir -p lemminx
unzip /tmp/lemminx.zip -d lemminx
rm -rf /tmp/lemminx.zip

# sqlls
cd ~/lsp
mkdir sql-language-server && cd sql-language-server && npm i sql-language-server

# tsgo (tsserver in golang)
cd ~/lsp
mkdir tsgo && cd tsgo && npm i @typescript/native-preview

# Reset
cd ~
