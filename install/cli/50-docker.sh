#!/usr/bin/env bash

# Docker setup

PACKAGE_NAME="Docker"
OS_CODENAME=noble

docker_install() {
  echo "Installing $PACKAGE_NAME..."
  
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $OS_CODENAME stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
  sudo usermod -aG docker ${USER}
  echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
  sudo usermod -aG dialout ${USER}
  
  echo "✓ $PACKAGE_NAME installed successfully"
  echo "Note: You may need to log out and back in for group changes to take effect"
}

docker_update() {
  if is_installed docker; then
    echo "Docker is managed by Ubuntu's apt"
  else
    echo "Docker is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) docker_install ;;
    update)  docker_update ;;
  esac
}

main "$@"
