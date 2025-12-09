#!/usr/bin/env bash

# Neovim LSP servers and tools

PACKAGE_NAME="Neovim LSP Servers"

lsp_install() {
  echo "Installing $PACKAGE_NAME..."
  
  mkdir -p ~/lsp/bin
  
  # [DAP] PHP Debug Adapter
  echo "Installing PHP Debug Adapter..."
  if [ ! -d ~/lsp/vscode-php-debug ]; then
    cd ~/lsp
    git clone https://github.com/xdebug/vscode-php-debug
  fi
  cd ~/lsp/vscode-php-debug
  npm install
  npm run build
  cd ~
  
  # [LSP] Phpactor
  echo "Installing Phpactor..."
  if [ ! -d ~/lsp/phpactor ]; then
    cd ~/lsp
    git clone https://github.com/phpactor/phpactor
  fi
  cd ~/lsp/phpactor
  git pull
  composer install --no-dev --optimize-autoloader
  ln -sf ~/lsp/phpactor/bin/phpactor ~/lsp/bin/
  rm -rf ~/.config/phpactor
  ln -sf ~/dotfiles/.config/phpactor ~/.config/phpactor
  cd ~
  
  # [LSP] LuaLS
  echo "Installing Lua Language Server..."
  LUALS_VERSION=$(curl -s "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
  curl -sLo /tmp/luals.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/${LUALS_VERSION}/lua-language-server-${LUALS_VERSION}-linux-x64.tar.gz"
  mkdir -p ~/lsp/lua-language-server
  tar xfp /tmp/luals.tar.gz -C ~/lsp/lua-language-server
  ln -sf ~/lsp/lua-language-server/bin/lua-language-server ~/lsp/bin/
  rm -rf /tmp/luals.tar.gz
  
  # [LSP] Node-based language servers
  echo "Installing Node-based language servers..."
  cd ~/lsp
  npm i intelephense \
    bash-language-server \
    twiggy-language-server \
    @microsoft/compose-language-service \
    vscode-langservers-extracted \
    sql-language-server \
    @typescript/native-preview
  ln -sf ~/lsp/node_modules/.bin/intelephense ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/bash-language-server ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/twiggy-language-server ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/docker-compose-langserver ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/vscode-json-language-server ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/sql-language-server ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/tsgo ~/lsp/bin/
  cd ~
  
  # [LSP] DockerLS
  echo "Installing Docker Language Server..."
  go install github.com/docker/docker-language-server/cmd/docker-language-server@latest
  
  # [LSP] YAMLLS
  echo "Installing YAML Language Server..."
  if [ ! -d ~/lsp/yaml-language-server ]; then
    cd ~/lsp
    git clone https://github.com/redhat-developer/yaml-language-server
  fi
  cd ~/lsp/yaml-language-server
  git pull
  npm install
  npm run build
  ln -sf ~/lsp/yaml-language-server/bin/yaml-language-server ~/lsp/bin/
  cd ~
  
  # [LSP] lemminx (XML)
  echo "Installing XML Language Server..."
  LEMMINX_VERSION=$(curl -s "https://api.github.com/repos/redhat-developer/vscode-xml/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
  curl -sLo /tmp/lemminx.zip "https://github.com/redhat-developer/vscode-xml/releases/download/${LEMMINX_VERSION}/lemminx-linux.zip"
  mkdir -p ~/lsp/lemminx
  unzip -o /tmp/lemminx.zip -d ~/lsp/lemminx
  rm -rf /tmp/lemminx.zip
  ln -sf ~/lsp/lemminx/lemminx-linux ~/lsp/bin/lemminx
  
  # [LSP] php-diagls
  echo "Installing PHP Diagnostics Language Server..."
  if [ ! -d ~/lsp/php-diagls ]; then
    cd ~/lsp
    git clone https://github.com/cristianradulescu/php-diagls
  fi
  cd ~/lsp/php-diagls
  git pull
  make build
  ln -sf ~/lsp/php-diagls/php-diagls ~/lsp/bin/
  cd ~
  
  # [FORMATTER] djlint
  echo "Installing djlint formatter..."
  pipx install --force djlint
  
  # [FORMATTER] sqlfluff
  echo "Installing sqlfluff formatter..."
  pipx install --force sqlfluff
  
  # [LSP-DEBUG]
  echo "Installing LSP dev tools..."
  pipx install --force lsp-devtools
  
  echo "✓ $PACKAGE_NAME installed/updated successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Updating $PACKAGE_NAME..."
    lsp_install
  else
    # When sourced (for initial install)
    lsp_install
  fi
}

main "$@"
