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
