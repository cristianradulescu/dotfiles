# vim:ft=zsh ts=2 sw=2 sts=2
#
# Standalone zsh configuration, no plugin framework required.

# Directory for the completion dump and completion cache
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

# -----------------------------------------------------------------------------
# History - without this zsh does not save history at all
# -----------------------------------------------------------------------------
[[ -z "$HISTFILE" ]] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000   # number of commands kept in memory
SAVEHIST=10000   # number of commands saved to HISTFILE

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# -----------------------------------------------------------------------------
# Options
# -----------------------------------------------------------------------------
setopt auto_cd              # type a directory name to cd into it
setopt auto_pushd           # cd pushes the old directory onto the directory stack
setopt pushd_ignore_dups    # don't push duplicate directories onto the stack
setopt pushdminus           # swap the meaning of +N and -N, so `cd -1` is the previous directory
setopt multios              # enable redirect to multiple streams: echo >file1 >file2
setopt long_list_jobs       # show long list format job notifications
setopt interactivecomments  # recognize comments
setopt ignoreeof            # Prevent Ctrl-D from exiting the shell

# Default pager, -R keeps colors in output piped to less
export PAGER="${PAGER:-less}"
export LESS="${LESS:--R}"

# Escape special characters in pasted URLs
autoload -Uz bracketed-paste-magic url-quote-magic
zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic

# -----------------------------------------------------------------------------
# Colors
# -----------------------------------------------------------------------------
# Set LS_COLORS (used by ls and the completion menu) if not already set
[[ -z "$LS_COLORS" ]] && (( $+commands[dircolors] )) && eval "$(dircolors -b)"

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
unsetopt menu_complete   # don't insert the first match on the first tab press
unsetopt flowcontrol     # free up Ctrl-S/Ctrl-Q (no terminal output freeze)
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word  # complete from the cursor position, not only at the end of the word
setopt always_to_end     # move the cursor to the end of the word after completing

# Module that provides the interactive completion menu
zmodload -i zsh/complist

# Navigate the completion menu with the arrow keys
zstyle ':completion:*:*:*:*:*' menu select
# Case-insensitive matching, then partial-word and substring matching
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
# Complete . and .. as directories
zstyle ':completion:*' special-dirs true
# Color files in the completion menu the same way as ls
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Highlight PIDs when completing kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# List only the current user's processes when completing process names
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
# cd completion order: local directories, then directory stack, then $cdpath
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
# Cache slow completions (e.g. apt, dpkg)
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# Initialize the completion system, -i skips insecure directories without prompting
autoload -Uz compinit
compinit -i -d "$ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION"

# -----------------------------------------------------------------------------
# Key bindings
# -----------------------------------------------------------------------------
# Use the emacs keymap: Ctrl+A/Ctrl+E line start/end, Ctrl+R history search, Alt+B/Alt+F word back/forward, ...
bindkey -e

# Make sure the terminal is in application mode while zle is active,
# otherwise the $terminfo key values are not valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() { echoti smkx }
  function zle-line-finish() { echoti rmkx }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Up/Down: search history for commands starting with what is already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search    # Up (normal mode): previous matching command
bindkey '^[[B' down-line-or-beginning-search  # Down (normal mode): next matching command
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search    # Up (application mode): previous matching command
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search  # Down (application mode): next matching command

[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line     # Home: move to the start of the line
[[ -n "${terminfo[kend]}" ]]  && bindkey "${terminfo[kend]}" end-of-line            # End: move to the end of the line
[[ -n "${terminfo[kcbt]}" ]]  && bindkey "${terminfo[kcbt]}" reverse-menu-complete  # Shift+Tab: previous entry in the completion menu
# Delete: delete the character under the cursor (falls back to the common escape code if terminfo has none)
[[ -n "${terminfo[kdch1]}" ]] && bindkey "${terminfo[kdch1]}" delete-char || bindkey '^[[3~' delete-char

bindkey '^[[1;5C' forward-word          # Ctrl+Right: move one word forward
bindkey '^[[1;5D' backward-word         # Ctrl+Left: move one word back
bindkey '^?' backward-delete-char       # Backspace: delete the character before the cursor
bindkey ' ' magic-space                 # Space: insert a space and expand history references (e.g. !!, !$)

# Ctrl+X Ctrl+E: edit the current command in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line        # Ctrl+X Ctrl+E: open the command line in $EDITOR, the saved text replaces it (not run)

# Ctrl+Space: accept the zsh-autosuggestions suggestion
bindkey '^ ' autosuggest-accept         # Ctrl+Space: accept the whole grey suggestion

# -----------------------------------------------------------------------------
# Terminal / tmux title
# -----------------------------------------------------------------------------
# usage: _cr_set_title short_tab_title long_window_title
function _cr_set_title() {
  setopt localoptions nopromptsubst
  case "$TERM" in
    xterm*|rxvt*|konsole*|alacritty*|foot*|wezterm*)
      print -Pn "\e]2;${2:q}\a" # set window name
      print -Pn "\e]1;${1:q}\a" # set tab name
      ;;
    screen*|tmux*)
      print -Pn "\e]2;${2:q}\e\\" # set tmux pane title
      print -Pn "\ek${1:q}\e\\"   # set tmux window name if `allow-rename` is on
      ;;
  esac
}

# While idle: tab title is the current directory (max 15 chars), window title is user@host:dir
function _cr_title_precmd() {
  _cr_set_title "%15<..<%~%<<" "%n@%m:%~"
}

# While a command runs: tab title is the command name, window title is the full command line
function _cr_title_preexec() {
  emulate -L zsh
  setopt extended_glob
  # cmd name only, or if this is sudo or ssh, the next cmd
  local cmd="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
  _cr_set_title "$cmd" "%100>...>${2:gs/%/%%}%<<"
}

# Report the cwd to the terminal (OSC 7), so new tabs/splits open in the same directory
function _cr_osc7_precmd() {
  [[ -n "$SSH_CLIENT$SSH_TTY" ]] && return
  local LC_ALL=C char url_path=''
  for char in ${(s::)PWD}; do
    [[ "$char" == [A-Za-z0-9/._~-] ]] && url_path+="$char" || url_path+=$(printf '%%%02X' "'$char")
  done
  printf '\e]7;file://%s%s\e\\' "$HOST" "$url_path"
}

# -----------------------------------------------------------------------------
# Prompt
#
# <user icon> user[@host] <separator> <dir icon> ~/dir <separator> <git icon> branch <dirty icon>
# <arrow>
# -----------------------------------------------------------------------------
# Re-evaluate ${_cr_git_info} in PROMPT every time the prompt is drawn
setopt prompt_subst

typeset -g _cr_separator=$'\U000F01D9'  # section separator
typeset -g _cr_session_icon=$''   # user icon
typeset -g _cr_dir_icon=$'\U000F0770'   # directory icon
typeset -g _cr_cmd_icon=$'➜'       # prompt arrow
typeset -g _cr_git_icon=$''       # git branch icon
typeset -g _cr_dirty_icon=$''     # uncommitted changes icon
typeset -g _cr_git_info=''

# Git info for the prompt: branch (or short sha when detached) + dirty marker.
# Untracked files count as dirty.
function _cr_git_precmd() {
  _cr_git_info=''
  local git_status
  git_status=$(GIT_OPTIONAL_LOCKS=0 git status --porcelain --branch 2>/dev/null) || return

  local ref
  ref=$(git symbolic-ref --short -q HEAD 2>/dev/null) \
    || ref=$(git rev-parse --short HEAD 2>/dev/null) \
    || return

  # First line of the output is the branch, anything after it is a change
  local dirty=''
  if [[ "$git_status" == *$'\n'* ]]; then
    dirty=" %F{yellow}%2{${_cr_dirty_icon}%}%f"
  fi

  # Escape % so branch names cannot inject prompt sequences
  _cr_git_info="${_cr_separator} ${_cr_git_icon} ${ref//\%/%%}${dirty} "
}

# SSH connection info: show @host and the client IP only in ssh sessions
typeset -g _cr_host=''
typeset -g _cr_ssh_connection=''
if [[ -n "$SSH_CLIENT$SSH_TTY" ]]; then
  _cr_host="@%m"
  [[ -n "$SSH_CLIENT" ]] && _cr_ssh_connection="(from ${SSH_CLIENT%% *}) "
fi

# Line 1: user (red when root), @host and ssh source over ssh, current directory, git info
# Line 2: arrow, green if the last command succeeded, red if it failed
PROMPT=$'\n'"%B${_cr_session_icon} %(!.%F{red}.%F{green})%n${_cr_host}%f%b ${_cr_ssh_connection}"
PROMPT+="${_cr_separator} %F{blue}${_cr_dir_icon} %~%f "
PROMPT+='${_cr_git_info}'
PROMPT+=$'\n'"%B%(?.%F{green}.%F{red})%1{${_cr_cmd_icon}%}%f%b "

# Run the functions above before each prompt (precmd) and before each command (preexec)
autoload -Uz add-zsh-hook
add-zsh-hook precmd _cr_git_precmd
add-zsh-hook precmd _cr_title_precmd
add-zsh-hook precmd _cr_osc7_precmd
add-zsh-hook preexec _cr_title_preexec

# -----------------------------------------------------------------------------
# User configuration
# -----------------------------------------------------------------------------

# Custom binaries
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/dotfiles/bin
# Go binaries
export PATH=$PATH:$HOME/go/bin
# Neovim LSPs
export PATH=$PATH:$HOME/lsp/bin
# Sometimes snaps are not loaded, adding to path works
[ -d "/snap/bin" ] && export PATH=$PATH:/snap/bin
# Rustup env
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Default editor for git, crontab, Ctrl+X Ctrl+E, ...
export EDITOR='nvim'

# Shared aliases and functions
[ -f "$HOME/dotfiles/.aliases" ] && source "$HOME/dotfiles/.aliases"
[ -f "$HOME/dotfiles/.functions" ] && source "$HOME/dotfiles/.functions"

# Work profile (sensitive data that cannot be commited)
[[ ! -f ~/.zshrc_work ]] || source ~/.zshrc_work

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Plugins from apt (zsh-syntax-highlighting must be sourced last)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null  # fish-like suggestions from history
source /etc/zsh_command_not_found 2>/dev/null                              # suggest apt package for unknown commands
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null  # highlight commands while typing
