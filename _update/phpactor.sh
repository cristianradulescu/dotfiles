#!/usr/bin/env bash

echo -e "\n[ Updating Phpactor ]"

cd /opt/phpactor && \
  git fetch --tags && \
  PHPACTOR_LAST_RELEASE=$(git tag -l "$(date +%Y).*" --sort -"version:refname" | head -n1) && \
  git checkout "$PHPACTOR_LAST_RELEASE" && \
  composer install --no-dev --optimize-autoloader

cd /opt/phpactor-unstable && \
  git pull && \
  composer install --no-dev --optimize-autoloader

