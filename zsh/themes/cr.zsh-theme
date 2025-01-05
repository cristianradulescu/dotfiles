# vim:ft=zsh ts=2 sw=2 sts=2
#
# Inspired by other themes: robbyrussel, bira

local section_separator="󰇙"

local session_icon="󰌢"
local user_host="%B%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})${session_icon} %n@%m%{$reset_color%}"

local current_dir_icon="󰝰"
local current_dir="${section_separator} %{$fg[blue]%}${current_dir_icon} %~ $reset_color%"

local cmd_icon="➜"
local cmd_status="%(?:%{$fg_bold[green]%}%1{${cmd_icon}%}:%{$fg_bold[red]%}%1{${cmd_icon}%})"

local git_info='$(git_prompt_info)'
local git_prompt_prefix_icon=""
local git_prompt_dirty_icon=""

# SSH connection info
local ssh_connection=
if [ -n "$SSH_CLIENT" ]; then 
  ssh_connection=$(echo "(from ")
  ssh_connection+=$(cut -d" " -f1 <<< $SSH_CLIENT)
  ssh_connection+=$(echo ") ")
fi

PROMPT="
${user_host} ${ssh_connection}${current_dir}"
PROMPT+=" ${git_info}"
PROMPT+="
${cmd_status} "

ZSH_THEME_GIT_PROMPT_PREFIX="${section_separator} ${git_prompt_prefix_icon} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}%2{${git_prompt_dirty_icon}%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
