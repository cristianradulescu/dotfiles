#!/usr/bin/env bash

# PHP development environment

PACKAGE_NAME="PHP Development"

php_install() {
  echo "Installing $PACKAGE_NAME..."
  sudo apt install -y php-cli php-xml composer
  curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash
  sudo apt install -y symfony-cli
  echo "✓ $PACKAGE_NAME installed successfully"
}

php_update() {
  if is_installed php; then
    echo "PHP and Composer are managed by Ubuntu's apt"
  else
    echo "PHP is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) php_install ;;
    update)  php_update ;;
  esac
}

main "$@"
