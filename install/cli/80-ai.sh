#!/usr/bin/env bash

# AI tools setup

PACKAGE_NAME="AI tools (gemini-cli, opencode)"

aitools_install() {
  echo "Installing $PACKAGE_NAME..."

  manage_npm_tool install "Gemini CLI"  gemini   @google/gemini-cli
  manage_npm_tool install "OpenCode AI" opencode opencode-ai

  if ! is_installed opencode && [ ! -f ~/.local/state/opencode/kv.json ]; then
    mkdir -p ~/.local/state/opencode
    cat << 'EOF' > ~/.local/state/opencode/kv.json
{
  "theme": "catppuccin"
}
EOF
  fi

  if is_installed claude; then
    log_skip "ClaudeCode CLI"
  else
    echo "Installing ClaudeCode CLI..."
    curl -fsSL https://claude.ai/install.sh | bash
  fi

  echo "✓ $PACKAGE_NAME installed successfully"
}

aitools_update() {
  echo "Updating $PACKAGE_NAME..."
  manage_npm_tool update "Gemini CLI"  gemini   @google/gemini-cli
  manage_npm_tool update "OpenCode AI" opencode opencode-ai
  if is_installed claude; then
    echo "Updating ClaudeCode CLI..."
    claude update
  else
    echo "ClaudeCode CLI is not installed, skipping"
  fi
}

main() {
  case "${1:-install}" in
    install) aitools_install ;;
    update)  aitools_update ;;
  esac
}

main "$@"
