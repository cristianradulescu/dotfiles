#!/usr/bin/env bash

# PHP development environment

PACKAGE_NAME="PHP Development"

php_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Install PHP and Composer
  sudo apt install -y php-cli php-xml composer
  
  # Install Symfony CLI
  curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash
  sudo apt install -y symfony-cli
  
  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v php >/dev/null 2>&1; then
      echo "✓ PHP is already installed"
      echo "PHP and Composer are managed by Ubuntu's apt"
    else
      php_install
    fi
  else
    # When sourced (for initial install)
    php_install
  fi
}

main "$@"
