export TERM=xterm-256color
export EDITOR="hx"

if command -v vivid &>/dev/null; then
    export VIVID_THEME="catppuccin-macchiato"
    export LS_COLORS=$(vivid generate)
fi

# XDG directories
export CALCHISTFILE="$XDG_STATE_HOME/calc_history"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"

export PATH="$CARGO_HOME/bin${PATH:+:}$PATH"

export HISTFILE="$XDG_STATE_HOME/ash/ash_history"
export HISTFILESIZE=100000
export HISTSIZE=10000
mkdir -p "$(dirname "$HISTFILE")"
