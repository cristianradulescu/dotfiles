#!/usr/bin/env bash

# CLI tools installation orchestrator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

ACTION="${1:-install}"

section "CLI Tools — $ACTION"

# Dev stack scripts are gated by env vars set in install.sh.
# When running standalone via 'dotfiles update', the vars are unset and
# the scripts are always executed (same as before).
_stack_enabled() {
  local var="$1"
  # If the variable is unset (standalone run), always proceed.
  # If explicitly set to 0, skip.
  [[ "${!var}" != "0" ]]
}

for script in "$SCRIPT_DIR"/cli/*.sh; do
  [ -f "$script" ] || continue

  name="$(basename "$script" .sh)"

  # Gate dev-stack scripts on user selection
  case "$name" in
    00-dev-php)    _stack_enabled INSTALL_STACK_PHP    || { log_info "Skipping PHP stack";    continue; } ;;
    00-dev-golang) _stack_enabled INSTALL_STACK_GO     || { log_info "Skipping Go stack";     continue; } ;;
    00-dev-nodejs) _stack_enabled INSTALL_STACK_NODEJS || { log_info "Skipping NodeJS stack"; continue; } ;;
    00-dev-rust)   _stack_enabled INSTALL_STACK_RUST   || { log_info "Skipping Rust stack";   continue; } ;;
    00-dev-bunjs)  _stack_enabled INSTALL_STACK_BUN    || { log_info "Skipping Bun stack";    continue; } ;;
  esac

  section "Running: $name"
  source "$script" "$ACTION"
done

section "✓ CLI tools $ACTION complete!"
