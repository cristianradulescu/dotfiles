#!/usr/bin/env bash

echo -e "\n[ Updating Phpactor ]"

cd ~/lsp/phpactor && \
  git pull && \
  composer install --no-dev --optimize-autoloader

