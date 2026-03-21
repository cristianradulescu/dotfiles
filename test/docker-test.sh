#!/usr/bin/env bash

# Run dotfiles install tests in an Ubuntu 24.04 Docker container.
#
# Usage:
#   ./test/docker-test.sh              # interactive shell
#   ./test/docker-test.sh --smoke      # automated smoke test (no prompts)
#   ./test/docker-test.sh --smoke --php --nodejs   # smoke test with specific stacks
#   ./test/docker-test.sh --rebuild    # force rebuild the image, then interactive

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

IMAGE_NAME="dotfiles-test"
CONTAINER_NAME="dotfiles-test-run"

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------

SMOKE=0
REBUILD=0
STACK_PHP=0
STACK_GO=0
STACK_NODEJS=0
STACK_RUST=0
STACK_BUN=0

for arg in "$@"; do
  case "$arg" in
    --smoke)   SMOKE=1 ;;
    --rebuild) REBUILD=1 ;;
    --php)     STACK_PHP=1 ;;
    --go)      STACK_GO=1 ;;
    --nodejs)  STACK_NODEJS=1 ;;
    --rust)    STACK_RUST=1 ;;
    --bun)     STACK_BUN=1 ;;
    --help|-h)
      echo "Usage: $(basename "$0") [options]"
      echo ""
      echo "Options:"
      echo "  --smoke          Run automated smoke test (no interactive prompts)"
      echo "  --rebuild        Force rebuild the Docker image"
      echo "  --php            Enable PHP stack in smoke test"
      echo "  --go             Enable Go stack in smoke test"
      echo "  --nodejs         Enable NodeJS stack in smoke test"
      echo "  --rust           Enable Rust stack in smoke test"
      echo "  --bun            Enable Bun stack in smoke test"
      exit 0
      ;;
  esac
done

# ---------------------------------------------------------------------------
# Build image (only if missing or --rebuild requested)
# ---------------------------------------------------------------------------

if [ "$REBUILD" = "1" ] || ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
  echo "Building $IMAGE_NAME image..."
  docker build -t "$IMAGE_NAME" "$SCRIPT_DIR"
else
  echo "Using existing $IMAGE_NAME image (pass --rebuild to refresh)"
fi

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------

DOCKER_ARGS=(
  --rm
  --name "$CONTAINER_NAME"
  # Mount dotfiles repo read-only so the container reflects current state
  -v "$DOTFILES_DIR:/home/cristian/dotfiles:ro"
  -e "HOME=/home/cristian"
)

if [ "$SMOKE" = "1" ]; then
  echo ""
  echo "Running smoke test..."
  DOCKER_ARGS+=(
    -e "INSTALL_STACK_PHP=$STACK_PHP"
    -e "INSTALL_STACK_GO=$STACK_GO"
    -e "INSTALL_STACK_NODEJS=$STACK_NODEJS"
    -e "INSTALL_STACK_RUST=$STACK_RUST"
    -e "INSTALL_STACK_BUN=$STACK_BUN"
  )
  docker run "${DOCKER_ARGS[@]}" "$IMAGE_NAME" bash /home/cristian/dotfiles/test/entrypoint.sh
else
  echo ""
  echo "Starting interactive shell. Dotfiles repo is at /home/cristian/dotfiles (read-only)."
  echo "To run the full CLI install:"
  echo "  source /home/cristian/dotfiles/install/lib.sh && source /home/cristian/dotfiles/install/cli.sh install"
  echo ""
  DOCKER_ARGS+=(-it)
  docker run "${DOCKER_ARGS[@]}" "$IMAGE_NAME" bash
fi
