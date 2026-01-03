#!/usr/bin/env bash

# AI tools setup

PACKAGE_NAME="AI tools (gemini-cli, opencode)"

aitools_install() {
  echo "Installing $PACKAGE_NAME..."

  echo "Installing Gemini CLI..."
  sudo npm install -g @google/gemini-cli

  echo "Installing OpenCode AI..."
  sudo npm i -g opencode-ai
  if [ ! -f ~/.local/state/opencode/kv.json ]; then
    mkdir -p ~/.local/state/opencode
    cat << 'EOF' > ~/.local/state/opencode/kv.json
  {
    "theme": "catppuccin"
  }
EOF
  fi

  echo "✓ $PACKAGE_NAME installed successfully"
}

# Main execution
main() {
  # When run directly (for updates)
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Updating $PACKAGE_NAME..."
    aitools_install
  else
    # When sourced (for initial install)
    aitools_install
  fi
}

main "$@"
