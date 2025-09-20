# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_CUSTOM=~/dotfiles/zsh/
ZSH_THEME="cr"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration
bindkey '^ ' autosuggest-accept 
setopt ignoreeof # Prevent Ctrl-D from exiting the shell

# zsh auto-completion
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/autojump/autojump.zsh 2>/dev/null
source /etc/zsh_command_not_found 2>/dev/null

# CAPS LOCK remap to CTRL
if [[ -n "$XDG_SESSION_TYPE" ]] && [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
  setxkbmap -option caps:ctrl_modifier
fi


# export MANPATH="/usr/local/man:$MANPATH"

# Custom binaries
export PATH=$PATH:/home/$USER/bin:/home/$USER/.local/bin
# Sometimes snaps are not loaded, adding to path works
[ -d "/snap/bin" ] && export PATH=$PATH:/snap/bin

# export LANG=en_US.UTF-8

export EDITOR='nvim'

[ -f "$HOME/dotfiles/.aliases" ] && source "$HOME/dotfiles/.aliases"

# Gemini API key
[ -f "$HOME/.codecompanion/gemini" ] && export GEMINI_API_KEY=$(cat "$HOME/.codecompanion/gemini")

# Work profile (sensitive data that cannot be commited)
[[ ! -f ~/.zshrc_work ]] || source ~/.zshrc_work

