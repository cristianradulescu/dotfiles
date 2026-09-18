# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for Ubuntu 24.04/25.10, managed by a custom bash installer framework (no GNU Stow / chezmoi — everything is hand-rolled). It provisions both CLI tools and GUI apps, and symlinks config files from this repo into `~/.config` and `$HOME`.

## Commands

```bash
dotfiles list                 # list all installable packages (cli/gui/optional)
dotfiles install <package>    # (re)install one package, e.g. `dotfiles install lazygit`
dotfiles update <package>     # update one package to latest, e.g. `dotfiles update neovim`
dotfiles update                # check/update all packages
```

`dotfiles` (bin/dotfiles) resolves a package name to a script under `install/{cli,gui,optional}/<package>.sh` and sources it with `install` or `update` as `$1`. Package name = script filename without `.sh` (with or without the numeric prefix, e.g. both `lazygit` and `60-lazygit` work).

Running a single script directly (without going through the `dotfiles` wrapper) requires sourcing `install/lib.sh` first for shared helpers:

```bash
source install/lib.sh
source install/cli/60-lazygit.sh install
```

### Testing

```bash
test/docker-test.sh              # interactive Ubuntu 24.04 container, dotfiles mounted read-only
test/docker-test.sh --smoke      # non-interactive smoke test of the full CLI install
test/docker-test.sh --smoke --php --nodejs   # smoke test with specific dev stacks enabled
test/docker-test.sh --rebuild    # force rebuild the test image
```

There's no unit test framework — validation is either `bash -n <script>` syntax checking or a full/smoke run in the Docker sandbox above. Never test destructive/system-modifying scripts against the host machine.

## Architecture

**Entry point**: `install.sh` (run via curl one-liner for fresh machines) clones the repo, interactively asks which dev stacks to enable (PHP/Go/NodeJS/Rust/Bun via `INSTALL_STACK_*` env vars), then sources `install/cli.sh install` and optionally `install/gui.sh install`.

**Orchestrators** (`install/cli.sh`, `install/gui.sh`): loop over every `*.sh` in their respective `install/cli/` or `install/gui/` directory in filename order (numeric prefixes like `00-`, `10-`, `20-` control sequencing) and source each with the action (`install`/`update`). `install/cli.sh` additionally gates the `00-dev-*` scripts on the `INSTALL_STACK_*` env vars — if unset (e.g. when a package is run standalone via `dotfiles update`), the stack script always runs.

**Package script contract**: every script under `install/{cli,gui,optional}/` is self-contained and follows the same shape:
- Defines `<name>_install()` and `<name>_update()` functions (update typically diffs installed vs. `github_latest` version and no-ops if current).
- A `main()` dispatches on `${1:-install}` to call one of the two.
- Ends with `main "$@"`.
- Relies on helpers from `install/lib.sh` being sourced first (`is_installed`, `github_latest`, `manage_npm_tool`, `section`, `log_ok`/`log_skip`/`log_info`) — these are not redeclared per-script.

`install/lib.sh` is the only shared library; there's no other cross-script coupling.

**Config symlinking**: package scripts that ship a config (e.g. neovim, lazygit) symlink from this repo into place as part of `_install()`, e.g. `ln -sf ~/dotfiles/.config/nvim ~/.config/`. When editing a tool's config, check whether its install script performs this symlink — the live config on a provisioned machine is this repo's copy, not a separate file.

**Adding a new package**: drop a new script into `install/cli/`, `install/gui/`, or `install/optional/` following the contract above; it's picked up automatically by `dotfiles list`/`install`/`update` and by the orchestrators — no registration elsewhere is needed. Use a numeric prefix to control install order relative to dependencies (e.g. base tools at `00-`/`10-`, things depending on them later).

## Key directories

- `.config/` — app configs symlinked into `~/.config` (nvim, tmux, waybar, sway, zed, wezterm, etc.). `.config/nvim` is the largest (Lua-based Neovim config under `lua/user/`, `lua/plugins/`, `lsp/`).
- `install/cli/`, `install/gui/`, `install/optional/` — one script per installable package, see contract above.
- `dev-setup/` — auxiliary dev tooling not tied to the installer framework (PHP Makefile, phpactor tweaks, a local reverse-proxy setup).
- `zsh/themes/cr.zsh-theme` — custom oh-my-zsh theme, loaded via `.zshrc`'s `ZSH_CUSTOM`.
- `bin/` — scripts added to `$PATH` by `.zshrc`, including the `dotfiles` CLI itself.
