#!/usr/bin/env bash

# Base system packages and tools

PACKAGE_NAME="Base System Tools"

base_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Update package list
  echo "Updating package list..."
  sudo apt update
  
  # Clean up unwanted packages
  echo "Cleaning up unwanted packages..."
  sudo apt remove -y --purge \
    brltty \
    xserver-xorg-input-wacom 2>/dev/null || true
  
  # Install base tools
  echo "Installing file management and build tools..."
  sudo apt install -y \
    curl wget \
    mc ranger \
    htop \
    ripgrep fd-find tree tldr \
    jq xq \
    unzip \
    apt-file \
    build-essential autoconf make cmake gettext g++ \
    libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses-dev \
    imagemagick redis-tools sqlite3 libsqlite3-dev libmysqlclient-dev \
    net-tools nmap dnsutils lsof \
    openjdk-21-jre openjdk-21-jdk \
    pipx
  
  # Add pipx binaries to PATH
  export PATH=$HOME/.local/bin:$PATH
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Base system packages are managed by Ubuntu's apt"
    echo "Run 'sudo apt update && sudo apt upgrade' to update them"
  else
    # When sourced (for initial install)
    base_install
  fi
}

main "$@"
