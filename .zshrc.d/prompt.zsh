autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats ' git:(%b)'

setopt PROMPT_SUBST

PROMPT='%B-> %F{cyan}%1~%f%F{yellow}${vcs_info_msg_0_}%f%b '
