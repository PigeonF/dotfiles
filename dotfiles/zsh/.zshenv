[ -n "${XDG_BIN_HOME:-}" ] || export XDG_BIN_HOME="${HOME}/.local/bin"
[ -n "${XDG_CACHE_HOME:-}" ] || export XDG_CACHE_HOME="${HOME}/.cache"
[ -n "${XDG_CONFIG_HOME:-}" ] || export XDG_CONFIG_HOME="${HOME}/.config"
[ -n "${XDG_DATA_HOME:-}" ] || export XDG_DATA_HOME="${HOME}/.local/share"
[ -n "${XDG_STATE_HOME:-}" ] || export XDG_STATE_HOME="${HOME}/.local/state"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
