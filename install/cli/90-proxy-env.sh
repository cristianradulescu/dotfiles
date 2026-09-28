#!/usr/bin/env bash

# Proxy Environment Setup for Sway

PACKAGE_NAME="Proxy Environment (Sway)"

proxy_env_install() {
    echo "Installing $PACKAGE_NAME..."

    # Ensure dev-setup/proxy directory exists
    mkdir -p ~/dotfiles/dev-setup/proxy

    # Copy proxy-env-setup.sh if not present
    if [[ ! -f ~/dotfiles/dev-setup/proxy/proxy-env-setup.sh ]]; then
        echo "  proxy-env-setup.sh not found, skipping copy"
    fi

    # Install systemd user service
    mkdir -p ~/.config/systemd/user
    cp ~/dotfiles/dev-setup/proxy/proxy-env.service ~/.config/systemd/user/proxy-env.service

    # Reload systemd user daemon
    systemctl --user daemon-reload

    # Enable the service (starts on graphical login)
    systemctl --user enable proxy-env.service

    echo "✓ $PACKAGE_NAME installed successfully"
    echo "Note: Run 'start-proxy.sh' to activate proxy and start the service"
}

proxy_env_update() {
    echo "Updating $PACKAGE_NAME..."

    # Update systemd user service
    mkdir -p ~/.config/systemd/user
    cp ~/dotfiles/dev-setup/proxy/proxy-env.service ~/.config/systemd/user/proxy-env.service

    # Reload systemd user daemon
    systemctl --user daemon-reload

    echo "✓ $PACKAGE_NAME updated successfully"
}

main() {
    case "${1:-install}" in
        install) proxy_env_install ;;
        update)  proxy_env_update ;;
    esac
}

main "$@"