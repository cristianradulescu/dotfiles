#!/usr/bin/env bash

# AI tools setup

PACKAGE_NAME="AI tools"

CLAUDE_MARKETPLACE="claude-plugins-official"
CLAUDE_PLUGINS=(
  feature-dev
  code-simplifier
  code-review
  security-guidance
  gopls-lsp
  php-lsp
  lua-lsp
  rust-analyzer-lsp
)

# Symlink config into ~/.claude and install plugins enabled in settings.json
claude_setup() {
  mkdir -p ~/.claude
  ln -sf ~/dotfiles/.config/claude/settings.json ~/.claude/settings.json
  ln -sf ~/dotfiles/.config/claude/statusline-command.sh ~/.claude/statusline-command.sh

  if ! claude plugin marketplace list 2>/dev/null | grep -q "$CLAUDE_MARKETPLACE"; then
    claude plugin marketplace add "anthropics/$CLAUDE_MARKETPLACE"
  fi

  local installed plugin
  installed=$(claude plugin list 2>/dev/null)
  for plugin in "${CLAUDE_PLUGINS[@]}"; do
    if grep -q "$plugin@$CLAUDE_MARKETPLACE" <<< "$installed"; then
      log_skip "Claude plugin $plugin"
    else
      echo "Installing Claude plugin $plugin..."
      claude plugin install "$plugin@$CLAUDE_MARKETPLACE"
    fi
  done
}

aitools_install() {
  echo "Installing $PACKAGE_NAME..."

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
    export PATH="$HOME/.local/bin:$PATH"
  fi
  claude_setup

  echo "✓ $PACKAGE_NAME installed successfully"
}

aitools_update() {
  echo "Updating $PACKAGE_NAME..."
  manage_npm_tool update "OpenCode AI" opencode opencode-ai
  if is_installed claude; then
    echo "Updating ClaudeCode CLI..."
    claude update
    claude_setup
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
