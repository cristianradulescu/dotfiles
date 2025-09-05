#!/usr/bin/env bash

DARKMODE="${1:-on}"

ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"
WEZTERM_CONFIG="$HOME/.config/wezterm/wezterm.lua"
LAZYGIT_CONFIG="$HOME/.config/lazygit/config.yml"
NVIM_CONFIG="$HOME/.config/nvim/lua/plugins/colors.lua"
TMUX_CONFIG="$HOME/.tmux.conf"

for config in "$ALACRITTY_CONFIG" "$WEZTERM_CONFIG" "$LAZYGIT_CONFIG" "$NVIM_CONFIG"; do
  if [ ! -f "$config" ]; then
    echo "Warning: $config not found."
  fi
done

if [[ "$DARKMODE" == "on" ]]; then
  sed -i 's/catppuccin-latte/catppuccin-mocha/g' "$ALACRITTY_CONFIG"
  sed -i 's/Catppuccin Latte/Catppuccin Mocha/g' "$WEZTERM_CONFIG"
  sed -i 's/catppuccin-latte/catppuccin-mocha/g' "$NVIM_CONFIG"
  sed -i 's/catppuccin-latte/catppuccin-mocha/g' "$TMUX_CONFIG"
  cp "$HOME/dotfiles/.config/lazygit/themes/catppuccin-mocha.yml" "$LAZYGIT_CONFIG"
else
  sed -i 's/catppuccin-mocha/catppuccin-latte/g' "$ALACRITTY_CONFIG"
  sed -i 's/Catppuccin Mocha/Catppuccin Latte/g' "$WEZTERM_CONFIG"
  sed -i 's/catppuccin-mocha/catppuccin-latte/g' "$NVIM_CONFIG"
  sed -i 's/catppuccin-mocha/catppuccin-latte/g' "$TMUX_CONFIG"
  cp "$HOME/dotfiles/.config/lazygit/themes/catppuccin-latte.yml" "$LAZYGIT_CONFIG"
fi

# Reload
if tmux info &>/dev/null; then
  tmux source-file ~/.tmux.conf
fi
