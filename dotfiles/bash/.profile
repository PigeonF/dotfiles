# Additional profiles to source

if [ -r "${XDG_STATE_HOME}/nix/profile/etc/profile.d/hm-session-vars.sh" ]; then
    . "${XDG_STATE_HOME}/nix/profile/etc/profile.d/hm-session-vars.sh"
fi

# XDG Base Directories
[ -n "${XDG_BIN_HOME:-}" ] || export XDG_BIN_HOME="${HOME}/.local/bin"
[ -n "${XDG_CACHE_HOME:-}" ] || export XDG_CACHE_HOME="${HOME}/.cache"
[ -n "${XDG_CONFIG_HOME:-}" ] || export XDG_CONFIG_HOME="${HOME}/.config"
[ -n "${XDG_DATA_HOME:-}" ] || export XDG_DATA_HOME="${HOME}/.local/share"
[ -n "${XDG_STATE_HOME:-}" ] || export XDG_STATE_HOME="${HOME}/.local/state"

# Program specific
export GHQ_ROOT="${HOME}/git"

# https://github.com/firecow/gitlab-ci-local/issues/1233
export GCL_ARTIFACTS_TO_SOURCE=false

# Make some programs adhere to the XDG directories
export BUILDX_CONFIG="${XDG_CONFIG_HOME}/buildx"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export DOTNET_CLI_HOME="${XDG_DATA_HOME}/dotnet"
export GCL_HOME="${XDG_CONFIG_HOME}"
export GOPATH="${XDG_DATA_HOME}/go"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NUPM_HOME="${XDG_DATA_HOME}/nupm"
export PYTHON_HISTORY="${XDG_CACHE_HOME}/python/history"
export REGCTL_CONFIG="${XDG_CONFIG_HOME}/regctl/config.json"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

# Path Adjustments
export PATH="${PATH}${PATH:+:}${XDG_BIN_HOME}:${CARGO_HOME}/bin:${XDG_DATA_HOME}/npm/bin:${GOPATH}/bin"

# Conditional Settings

{{#if (is_executable "nvim") }}
export EDITOR=nvim
{{/if}}
