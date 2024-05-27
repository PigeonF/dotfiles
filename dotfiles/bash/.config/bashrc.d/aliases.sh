alias fda="fd --hidden"
alias fdA="fd --no-ignore --hidden"
alias la="ls -la"
alias rga="rg --hidden"
alias rgA="rg --no-ignore --hidden"
alias wget="wget --hsts-file ${XDG_CACHE_HOME}/wget/hsts"

{{#if (is_executable "cargo") }}
alias c="cargo"
{{/if}}

{{#if (is_executable "git")}}
alias g="git"
{{/if}}

{{#if (is_executable "eza") }}
alias ls="eza"
{{/if}}


{{#if (is_executable "nvim") }}
alias vi="nvim"
alias vim="nvim"
{{/if}}
