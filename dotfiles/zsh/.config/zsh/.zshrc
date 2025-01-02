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

alias fda="fd --hidden"
alias fdA="fd --no-ignore --hidden"
alias la="ls -la"
alias rga="rg --hidden"
alias rgA="rg --no-ignore --hidden"

{{#if (is_executable "cargo") }}
alias c="cargo"
{{/if}}

{{#if (is_executable "eza") }}
alias ls="eza"
{{/if}}

{{#if (is_executable "git")}}
alias g="git"
{{/if}}

{{#if (is_executable "git")}}
alias jjj="jj --ignore-working-copy"
{{/if}}

{{#if (is_executable "nvim") }}
alias vi="nvim"
alias vim="nvim"
{{/if}}

{{#if (is_executable "wget") }}
alias wget="wget --hsts-file="${XDG_DATA_HOME}/wget-hsts""
{{/if}}

{{#if (is_executable "yarn") }}
alias yarn="yarn --use-yarnrc "${XDG_CONFIG_HOME}/yarn/config""
{{/if}}


autoload -Uz compinit bashcompinit
compinit
bashcompinit

bindkey -e
bindkey \^K kill-line
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
