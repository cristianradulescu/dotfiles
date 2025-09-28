#!/usr/bin/env bash

mkdir -p ~/lsp/bin

# [DAP] PHP Debug Adapter
cd ~/lsp
git clone https://github.com/xdebug/vscode-php-debug
cd vscode-php-debug && npm install && npm run build

# [LSP] Sonarlint
cd ~/lsp
SONARLINT_VSCODE_EXT_VERSION=$(curl -s "https://api.github.com/repos/SonarSource/sonarlint-vscode/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
curl -Lo /tmp/sonarlint.zip "https://github.com/SonarSource/sonarlint-vscode/releases/latest/download/sonarlint-vscode-linux-x64-${SONARLINT_VSCODE_EXT_VERSION}.vsix"
mkdir -p vscode-sonarlint
unzip /tmp/sonarlint.zip -d vscode-sonarlint
rm -rf /tmp/sonarlint.zip

# [LSP] Phpactor
cd ~/lsp
git clone https://github.com/phpactor/phpactor
cd phpactor && composer install --no-dev --optimize-autoloader
ln -s ~/lsp/phpactor/bin/phpactor ~/lsp/bin/
rm -rf ~/.config/phpactor && ln -s ~/dotfiles/.config/phpactor ~/.config/phpactor

# [LSP] LuaLS
cd ~/lsp
LUALS_VERSION=$(curl -s "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
curl -Lo /tmp/luals.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/${LUALS_VERSION}/lua-language-server-${LUALS_VERSION}-linux-x64.tar.gz"
mkdir -p lua-language-server
tar xvfp /tmp/luals.tar.gz -C lua-language-server
ln -s ~/lsp/lua-language-server/bin/lua-language-server ~/lsp/bin/
rm -rf /tmp/luals.tar.gz

# [LSP]
cd ~/lsp
npm i intelephense \
  bash-language-server \
  twiggy-language-server \
  @microsoft/compose-language-service \
  vscode-langservers-extracted \
  sql-language-server \
  @typescript/native-preview
ln -s ~/lsp/node_modules/.bin/intelephense ~/lsp/bin/
ln -s ~/lsp/node_modules/.bin/bash-language-server ~/lsp/bin/
ln -s ~/lsp/node_modules/.bin/twiggy-language-server ~/lsp/bin/
ln -s ~/lsp/node_modules/.bin/docker-compose-langserver ~/lsp/bin/
ln -s ~/lsp/node_modules/.bin/vscode-json-language-server ~/lsp/bin/
ln -s ~/lsp/node_modules/.bin/tsgo ~/lsp/bin/

# [LSP] DockerLS
go install github.com/docker/docker-language-server/cmd/docker-language-server@latest

# [lsp] yamlls
cd ~/lsp
git clone https://github.com/redhat-developer/yaml-language-server
cd yaml-language-server && npm install && npm run build
ln -s ~/lsp/yaml-language-server/bin/yaml-language-server ~/lsp/bin/

# [LSP] lemminx (xml)
cd ~/lsp
LEMMINX_VERSION=$(curl -s "https://api.github.com/repos/redhat-developer/vscode-xml/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
curl -Lo /tmp/lemminx.zip "https://github.com/redhat-developer/vscode-xml/releases/download/${LEMMINX_VERSION}/lemminx-linux.zip"
mkdir -p lemminx
unzip /tmp/lemminx.zip -d lemminx
rm -rf /tmp/lemminx.zip
ln -s ~/lsp/lemminx/lemminx-linux ~/lsp/bin/lemminx

# [LSP] php-diagls
git clone https://github.com/cristianradulescu/php-diagls
cd php-diagls
make build
ln -s ~/lsp/php-diagls/php-diagls ~/lsp/bin/

# [FORMATTER] djlint 
pipx install --force djlint

# [FORMATTER] sqlfluff
pipx install --force sqlfluff

# [LSP-DEBUG]
pipx install --force lsp-devtools

# Reset
cd ~
