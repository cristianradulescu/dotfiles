#!/usr/bin/env bash

echo -e "\n[ Updating Sonarlint ]"

# check if the externsion.vsixmanifest file exists
if [ ! -f ~/lsp/vscode-sonarlint/extension.vsixmanifest ]; then
  exit 0
fi

INSTALLED_VERSION=$(cat ~/lps/vscode-sonarlint/extension.vsixmanifest | xq -x /PackageManifest/Metadata/Identity/@Version)
LATEST_VERSION=$(curl -s "https://api.github.com/repos/SonarSource/sonarlint-vscode/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating Sonarlint from $INSTALLED_VERSION to $LATEST_VERSION"
  curl -Lo /tmp/sonarlint.zip "https://github.com/SonarSource/sonarlint-vscode/releases/latest/download/sonarlint-vscode-linux-x64-${LATEST_VERSION}.vsix"
  unzip /tmp/sonarlint.zip -d ~/lsp/vscode-sonarlint
  rm -rf /tmp/sonarlint.zip
else
  echo "Sonarlint is already up to date (version $INSTALLED_VERSION)"
fi

