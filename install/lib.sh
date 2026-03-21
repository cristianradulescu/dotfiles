#!/usr/bin/env bash

# Shared helpers for all install/update scripts
# Usage: source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------

section() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

log_ok()   { echo "✓ $1"; }
log_skip() { echo "  $1 — already installed, skipping"; }
log_info() { echo "  $1"; }

# ---------------------------------------------------------------------------
# Tool detection
# ---------------------------------------------------------------------------

is_installed() {
  command -v "$1" &>/dev/null
}

# ---------------------------------------------------------------------------
# GitHub release helpers
# ---------------------------------------------------------------------------

# github_latest <owner/repo>
# Returns the latest release tag (without leading 'v')
github_latest() {
  curl -s "https://api.github.com/repos/$1/releases/latest" \
    | grep -Po '"tag_name": "v?\K[^"]*'
}

# ---------------------------------------------------------------------------
# npm global package helper
# manage_npm_tool <install|update> <display_name> <binary> <package>
# ---------------------------------------------------------------------------

manage_npm_tool() {
  local action="$1"
  local name="$2"
  local bin="$3"
  local package="$4"

  if [ "$action" = "install" ]; then
    if is_installed "$bin"; then
      log_skip "$name"
    else
      log_info "Installing $name..."
      sudo npm i -g "$package"
    fi
  elif [ "$action" = "update" ]; then
    if is_installed "$bin"; then
      log_info "Updating $name..."
      sudo npm update -g "$package"
    else
      log_info "$name is not installed, skipping"
    fi
  fi
}
