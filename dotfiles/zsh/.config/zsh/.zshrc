[[ $- == *i* ]] || return

if [ -d "${XDG_CONFIG_HOME}/zshrc.d" ]; then
  find "${XDG_CONFIG_HOME}/zshrc.d" -type f -iname "*.zsh" -print0 | while IFS= read -r -d '' file; do
    if [ -r "$file" ]; then
      . "$file"
    fi
  done
fi

setopt GLOB_DOTS

{{#if (is_executable "atuin")}}
eval "$(atuin init zsh --disable-up-arrow)"
{{/if}}

{{#if (is_executable "starship")}}
if [[ "$TERM" != "dumb" ]]; then
  eval "$(starship init zsh --print-full-init)"
fi
{{/if}}

{{#if (is_executable "zoxide")}}
eval "$(zoxide init zsh)"
{{/if}}

{{#if (is_executable "/opt/homebrew/bin/brew")}}
eval "$(/opt/homebrew/bin/brew shellenv)"
{{/if}}

autoload -Uz compinit bashcompinit
compinit
bashcompinit

bindkey -e
