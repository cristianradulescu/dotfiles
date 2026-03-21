#!/usr/bin/env bash

# GUI tools installation orchestrator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

ACTION="${1:-install}"

section "GUI Tools — $ACTION"

for script in "$SCRIPT_DIR"/gui/*.sh; do
  [ -f "$script" ] || continue

  name="$(basename "$script" .sh)"
  section "Running: $name"
  source "$script" "$ACTION"
done

section "✓ GUI tools $ACTION complete!"
