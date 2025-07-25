#!/usr/bin/env bash

echo -e "\n[ Updating Sonarlint ]"

# check if the externsion.vsixmanifest file exists
if [ ! -f /opt/vscode-sonarlint/extension.vsixmanifest ]; then
  exit 0
fi

INSTALLED_VERSION=$(cat /opt/vscode-sonarlint/extension.vsixmanifest | xq -x /PackageManifest/Metadata/Identity/@Version)
LATEST_VERSION=$(curl -s "https://api.github.com/repos/SonarSource/sonarlint-vscode/releases/latest" | grep -Po '"name": "\K[^"]*' | head -n 1)
if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
  echo "Updating Sonarlint from $INSTALLED_VERSION to $LATEST_VERSION"
  curl -Lo sonarlint.zip "https://github.com/SonarSource/sonarlint-vscode/releases/latest/download/sonarlint-vscode-linux-x64-${LATEST_VERSION}.vsix"
  sudo mkdir -p /opt/vscode-sonarlint
  sudo chown -R "$USER:$USER" /opt/vscode-sonarlint
  unzip sonarlint.zip -d /opt/vscode-sonarlint
  rm -rf sonarlint.zip
else
  echo "Sonarlint is already up to date (version $INSTALLED_VERSION)"
fi

