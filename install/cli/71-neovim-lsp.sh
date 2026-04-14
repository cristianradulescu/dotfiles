#!/usr/bin/env bash

# Neovim LSP servers and tools

PACKAGE_NAME="Neovim LSP Servers"

lsp_clone_or_pull() {
  local repo="$1" dir="$2"
  if [ ! -d "$dir" ]; then
    git clone "$repo" "$dir"
  fi
  cd "$dir" && git pull
}

lsp_install() {
  echo "Installing $PACKAGE_NAME..."
  mkdir -p ~/lsp/bin

  # [DAP] PHP Debug Adapter
  echo "Installing PHP Debug Adapter..."
  lsp_clone_or_pull https://github.com/xdebug/vscode-php-debug ~/lsp/vscode-php-debug
  npm install && npm run build
  cd ~

  # [LSP] Phpactor
  echo "Installing Phpactor..."
  lsp_clone_or_pull https://github.com/phpactor/phpactor ~/lsp/phpactor
  composer install --no-dev --optimize-autoloader
  ln -sf ~/lsp/phpactor/bin/phpactor ~/lsp/bin/
  rm -rf ~/.config/phpactor && ln -sf ~/dotfiles/.config/phpactor ~/.config/phpactor
  cd ~

  # [LSP] LuaLS
  echo "Installing Lua Language Server..."
  local LUALS_VERSION
  LUALS_VERSION=$(github_latest LuaLS/lua-language-server)
  curl -sLo /tmp/luals.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/${LUALS_VERSION}/lua-language-server-${LUALS_VERSION}-linux-x64.tar.gz"
  mkdir -p ~/lsp/lua-language-server
  tar xfp /tmp/luals.tar.gz -C ~/lsp/lua-language-server
  ln -sf ~/lsp/lua-language-server/bin/lua-language-server ~/lsp/bin/
  rm -f /tmp/luals.tar.gz

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
  ln -sf ~/lsp/node_modules/.bin/intelephense           ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/bash-language-server   ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/twiggy-language-server ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/docker-compose-langserver ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/vscode-json-language-server ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/sql-language-server    ~/lsp/bin/
  ln -sf ~/lsp/node_modules/.bin/tsgo                   ~/lsp/bin/
  cd ~

  # [LSP] DockerLS
  echo "Installing Docker Language Server..."
  go install github.com/docker/docker-language-server/cmd/docker-language-server@latest

  # [LSP] YAMLLS
  echo "Installing YAML Language Server..."
  lsp_clone_or_pull https://github.com/redhat-developer/yaml-language-server ~/lsp/yaml-language-server
  npm install && npm run build
  ln -sf ~/lsp/yaml-language-server/bin/yaml-language-server ~/lsp/bin/
  cd ~

  # [LSP] lemminx (XML)
  echo "Installing XML Language Server..."
  local LEMMINX_VERSION
  LEMMINX_VERSION=$(github_latest redhat-developer/vscode-xml)
  curl -sLo /tmp/lemminx.zip "https://github.com/redhat-developer/vscode-xml/releases/download/${LEMMINX_VERSION}/lemminx-linux.zip"
  mkdir -p ~/lsp/lemminx && unzip -o /tmp/lemminx.zip -d ~/lsp/lemminx
  rm -f /tmp/lemminx.zip
  ln -sf ~/lsp/lemminx/lemminx-linux ~/lsp/bin/lemminx

  # [LSP] php-diagls
  echo "Installing PHP Diagnostics Language Server..."
  lsp_clone_or_pull https://github.com/cristianradulescu/php-diagls ~/lsp/php-diagls
  make build
  ln -sf ~/lsp/php-diagls/php-diagls ~/lsp/bin/
  cd ~

  # [FORMATTER] djlint, sqlfluff, lsp-devtools
  pipx install --force djlint
  pipx install --force sqlfluff
  pipx install --force lsp-devtools

  # [FORMATTER] Stylua
  cargo install stylua

  # [TREESITTER]
  cargo install --locked tree-sitter-cli

  echo "✓ $PACKAGE_NAME installed successfully"
}

lsp_update() {
  echo "Updating $PACKAGE_NAME..."

  # Git-based servers: pull + rebuild
  cd ~/lsp/vscode-php-debug && git pull && npm install && npm run build && cd ~
  cd ~/lsp/phpactor          && git pull && composer install --no-dev --optimize-autoloader && cd ~
  cd ~/lsp/yaml-language-server && git pull && npm install && npm run build && cd ~
  cd ~/lsp/php-diagls        && git pull && make build && cd ~

  # LuaLS: re-download latest
  local LUALS_VERSION
  LUALS_VERSION=$(github_latest LuaLS/lua-language-server)
  curl -sLo /tmp/luals.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/${LUALS_VERSION}/lua-language-server-${LUALS_VERSION}-linux-x64.tar.gz"
  mkdir -p ~/lsp/lua-language-server
  tar xfp /tmp/luals.tar.gz -C ~/lsp/lua-language-server
  rm -f /tmp/luals.tar.gz

  # lemminx: re-download latest
  local LEMMINX_VERSION
  LEMMINX_VERSION=$(github_latest redhat-developer/vscode-xml)
  curl -sLo /tmp/lemminx.zip "https://github.com/redhat-developer/vscode-xml/releases/download/${LEMMINX_VERSION}/lemminx-linux.zip"
  unzip -o /tmp/lemminx.zip -d ~/lsp/lemminx
  rm -f /tmp/lemminx.zip

  # Node-based servers: npm update
  cd ~/lsp && npm update && cd ~

  # DockerLS: re-install via Go
  go install github.com/docker/docker-language-server/cmd/docker-language-server@latest

  # Python formatters
  pipx upgrade djlint
  pipx upgrade sqlfluff
  pipx upgrade lsp-devtools

  # Stylua
  cargo install stylua

  # [TREESITTER]
  cargo install --locked tree-sitter-cli

  echo "✓ $PACKAGE_NAME updated successfully"
}

main() {
  case "${1:-install}" in
    install) lsp_install ;;
    update)  lsp_update ;;
  esac
}

main "$@"
