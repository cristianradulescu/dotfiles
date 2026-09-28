#!/bin/bash

# Proxy Environment Setup for Graphical Session
# This script is called by the systemd user service to export proxy
# environment variables to the user's graphical session.

set -euo pipefail

# Configuration - matches start-proxy.sh
SOCKS_PORT=1080
PAC_PORT=8800

# Proxy environment variables
export http_proxy="socks5://localhost:${SOCKS_PORT}"
export https_proxy="socks5://localhost:${SOCKS_PORT}"
export all_proxy="socks5://localhost:${SOCKS_PORT}"
export no_proxy="localhost,127.0.0.1,::1"
export PROXY_PAC_URL="http://localhost:${PAC_PORT}/proxy.pac"

# Export to systemd user session
systemctl --user import-environment \
    http_proxy \
    https_proxy \
    all_proxy \
    no_proxy \
    PROXY_PAC_URL 2>/dev/null || true

# Update D-Bus activation environment for apps launched via D-Bus
dbus-update-activation-environment --systemd \
    http_proxy \
    https_proxy \
    all_proxy \
    no_proxy \
    PROXY_PAC_URL 2>/dev/null || true

# Also update the current environment for any child processes
# (This is mostly for the service's own RemainAfterExit=yes)
echo "Proxy environment variables exported to graphical session"
echo "  http_proxy=${http_proxy}"
echo "  https_proxy=${https_proxy}"
echo "  all_proxy=${all_proxy}"
echo "  no_proxy=${no_proxy}"
echo "  PROXY_PAC_URL=${PROXY_PAC_URL}"