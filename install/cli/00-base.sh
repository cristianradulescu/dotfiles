#!/usr/bin/env bash

# Base system packages and tools

PACKAGE_NAME="Base System Tools"

base_install() {
  echo "Installing $PACKAGE_NAME..."
  
  sudo apt update
  
  sudo apt remove -y --purge \
    brltty \
    xserver-xorg-input-wacom 2>/dev/null || true
  
  sudo apt install -y \
    curl wget \
    mc ranger \
    htop \
    ripgrep fd-find tree pv \
    jq xq \
    unzip \
    apt-file \
    build-essential autoconf make cmake gettext g++ ninja-build clang \
    libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses-dev \
    imagemagick redis-tools sqlite3 libsqlite3-dev libmysqlclient-dev \
    net-tools nmap dnsutils lsof \
    openjdk-21-jre openjdk-21-jdk \
    pipx
  
  export PATH=$HOME/.local/bin:$PATH
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

base_update() {
  echo "Base system packages are managed by Ubuntu's apt"
  echo "Run 'sudo apt update && sudo apt upgrade' to update them"
}

main() {
  case "${1:-install}" in
    install) base_install ;;
    update)  base_update ;;
  esac
}

main "$@"
