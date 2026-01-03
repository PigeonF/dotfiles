if command -v starship &>/dev/null; then
    export PS1='$(starship prompt --status "$?" --path "$PWD")'
fi
