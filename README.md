# My Dotfiles Setup

Personal dotfiles repository for setting up a development environment on **Ubuntu 24.04 LTS / 25.10**

## Quick Start

### Full Installation

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/cristianradulescu/dotfiles/master/install.sh)"
```

## Usage

### List Available Packages

```bash
dotfiles list
```

### Update All Packages

```bash
dotfiles update
```

### Update Specific Package

```bash
dotfiles update lazygit
dotfiles update neovim
dotfiles update 60-lazygit  # Can also use the full filename
```

### Install/Reinstall Specific Package

```bash
dotfiles install lazygit
dotfiles install vscode
```

## Manual Installation

Install packages individually without running the full installer:

```bash
cd ~/dotfiles
source install/cli/60-lazygit.sh
source install/gui/30-wezterm.sh
```

## Desktop Environments

- **Primary**: Gnome (Ubuntu default)
- **Alternative**: Sway (Wayland compositor)

