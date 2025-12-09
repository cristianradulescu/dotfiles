#!/usr/bin/env bash

# Docker setup

PACKAGE_NAME="Docker"
OS_CODENAME=noble

docker_install() {
  echo "Installing $PACKAGE_NAME..."
  
  # Add the official Docker repo
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $OS_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  
  # Install Docker engine and standard plugins
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
  
  # Give this user privileged Docker access
  sudo usermod -aG docker ${USER}
  
  # Limit log size to avoid running out of disk
  echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
  
  # Add user to dialout group (for Arduino IDE, Thonny, etc.)
  sudo usermod -aG dialout ${USER}
  
  echo "✓ $PACKAGE_NAME installed successfully"
  echo "Note: You may need to log out and back in for group changes to take effect"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if command -v docker >/dev/null 2>&1; then
      echo "✓ Docker is already installed"
      echo "Docker is managed by Ubuntu's apt"
    else
      docker_install
    fi
  else
    # When sourced (for initial install)
    docker_install
  fi
}

main "$@"
