#!/usr/bin/env bash

# Smoke test entrypoint — runs inside the container.
# Skips interactive prompts by pre-setting all INSTALL_STACK_* vars.
# Individual stacks can be toggled via env vars passed to docker run:
#   -e INSTALL_STACK_PHP=1 -e INSTALL_STACK_GO=0 ...

set -e

DOTFILES_DIR="${DOTFILES_DIR:-/home/cristian/dotfiles}"

source "$DOTFILES_DIR/install/lib.sh"

# ---------------------------------------------------------------------------
# Dev stack defaults (all off unless explicitly enabled)
# ---------------------------------------------------------------------------
export INSTALL_STACK_PHP="${INSTALL_STACK_PHP:-0}"
export INSTALL_STACK_GO="${INSTALL_STACK_GO:-0}"
export INSTALL_STACK_NODEJS="${INSTALL_STACK_NODEJS:-0}"
export INSTALL_STACK_RUST="${INSTALL_STACK_RUST:-0}"
export INSTALL_STACK_BUN="${INSTALL_STACK_BUN:-0}"

section "Dotfiles smoke test"
echo "  PHP    : $INSTALL_STACK_PHP"
echo "  Go     : $INSTALL_STACK_GO"
echo "  NodeJS : $INSTALL_STACK_NODEJS"
echo "  Rust   : $INSTALL_STACK_RUST"
echo "  Bun    : $INSTALL_STACK_BUN"

# ---------------------------------------------------------------------------
# Run CLI install
# ---------------------------------------------------------------------------

source "$DOTFILES_DIR/install/cli.sh" install

section "✓ Smoke test complete"
