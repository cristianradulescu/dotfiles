#!/usr/bin/env bash

echo -e "\n[ Updating Lazygit ]"

INSTALLED_VERSION=$(lazygit --version | tr -s ', ' ' ' | awk '{print $6}' | cut -d"=" -f2)
LATEST_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating Lazygit from $INSTALLED_VERSION to $LATEST_VERSION"
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LATEST_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -rf lazygit lazygit.tar.gz
else
  echo "Lazygit is already up to date (version $INSTALLED_VERSION)"
fi
