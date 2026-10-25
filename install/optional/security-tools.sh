#!/usr/bin/env bash

# Network/security tools - capture, recon, web testing, proxies/VPN

PACKAGE_NAME="Security Tools"

SECURITY_TOOLS_PACKAGES=(
  # Capture & basics
  wireshark tcpdump nmap dnsutils netcat-openbsd
  # Network & recon
  masscan arp-scan netdiscover ncat socat whois traceroute mtr-tiny
  # Web testing
  sqlmap nikto gobuster ffuf wfuzz dirb
  # Proxies, VPN & anonymity
  proxychains4 openvpn tor
)

security_tools_install() {
  echo "Installing $PACKAGE_NAME..."

  # Allow non-root users in the wireshark group to capture packets (skips the debconf prompt)
  echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
  sudo DEBIAN_FRONTEND=noninteractive apt install -y "${SECURITY_TOOLS_PACKAGES[@]}"
  sudo usermod -aG wireshark "$USER"

  echo "✓ $PACKAGE_NAME installed successfully (log out and back in for wireshark group membership)"
}

security_tools_update() {
  if is_installed nmap; then
    echo "$PACKAGE_NAME are managed by Ubuntu's apt"
  else
    echo "$PACKAGE_NAME are not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) security_tools_install ;;
    update)  security_tools_update ;;
  esac
}

main "$@"
