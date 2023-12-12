ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[magenta]%}%%"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[red]%}~"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}?"

function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

PROMPT='%(?, ,%{$fg[red]%}FAIL%{$reset_color%}
)
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}: %{$fg_bold[blue]%}%~%{$reset_color%}$(git_prompt_info)$(git_prompt_status)%{$reset_color%}
$(prompt_char) '

RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'
