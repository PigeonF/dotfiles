alias c=cargo

if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --plain'
fi

alias fdA='fd --hidden --no-ignore'
alias fda='fd --hidden'
alias g=git
alias jjj='jj --ignore-working-copy'

if comamnd -v eza &>/dev/null; then
  alias la='eza --long --all'
  alias ll='eza -l'
  alias lla='eza -la'
  alias ls=eza
  alias lt='eza --tree'
fi

alias rgA='rg --hidden --no-ignore'
alias rga='rg --hidden'
