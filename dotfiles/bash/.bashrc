[[ $- == *i* ]] || return

for file in "${XDG_CONFIG_HOME}/bashrc.d"/*.sh; do
  if [ -r "$file" ]; then
    . "$file"
  fi
done

HISTFILE="/home/pigeon/.local/state/bash/bash_history.txt"
HISTFILESIZE=100000
HISTIGNORE='ls:exit'
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

alias fda='fd --no-ignore --hidden'
alias la='ls -la'
alias ls='eza'
alias rga='rg --no-ignore --hidden'

{{#if (is_executable "atuin") }}
if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
  eval "$(atuin init bash --disable-up-arrow)"
fi
{{/if}}

{{#if (is_executable "starship") }}
if [[ $TERM != "dumb" ]]; then
  eval "$(starship init bash --print-full-init)"
fi
{{/if}}

{{#if (is_executable "zoxide") }}
eval "$(zoxide init bash)"
{{/if}}
