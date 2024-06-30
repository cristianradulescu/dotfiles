# vim:ft=zsh ts=2 sw=2 sts=2
#
# Inspired by other themes: robbyrussel, bira

local user_host="%B%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n@%m%{$reset_color%} "

# SSH connection info
local ssh_connection=
if [ -n "$SSH_CLIENT" ]; then 
  ssh_connection=$(echo "(from ")
  ssh_connection+=$(cut -d" " -f1 <<< $SSH_CLIENT)
  ssh_connection+=$(echo ") ")
fi

PROMPT="${user_host}${ssh_connection}%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} )%{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
