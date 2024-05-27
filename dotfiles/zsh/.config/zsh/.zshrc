[[ $- == *i* ]] || return

for file in "${XDG_CONFIG_HOME}/zshrc.d"/*.zsh; do
  if [ -r "$file" ]; then
    . "$file"
  fi
done

HISTFILE="${XDG_STATE_HOME}/zsh/zsh_history.txt"
HISTORY_IGNORE='(ls|exit)'
HISTSIZE=10000

{{#if (is_executable "atuin")}}
if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi
{{/if}}

{{#if (is_executable "starship")}}
if [[ $TERM != "dumb" ]]; then
  eval "$(starship init zsh --print-full-init)"
fi
{{/if}}

{{#if (is_executable "zoxide")}}
eval "$(zoxide init zsh)"
{{/if}}
