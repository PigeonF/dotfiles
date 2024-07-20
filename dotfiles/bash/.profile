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

# Make some programs adhere to the XDG directories
export DOTNET_CLI_HOME="${XDG_DATA_HOME}/dotnet"

# Path Adjustments
export PATH="${PATH}${PATH:+:}${XDG_BIN_HOME}"

# Conditional Settings

{{#if (is_executable "cargo") }}
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export PATH="${CARGO_HOME}/bin${PATH:+:}${PATH}"
{{/if}}

{{#if (is_executable "docker") }}
export BUILDX_CONFIG="${XDG_CONFIG_HOME}/buildx"
export BUILDX_NO_DEFAULT_ATTESTATIONS=true
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
{{/if}}

{{#if (is_executable "ghq") }}
export GHQ_ROOT="${HOME}/git"
{{/if}}

{{#if (is_executable "gitlab-ci-local") }}
export CI_PYPI_REPOSITORY=http://pypi.internal:8080
export GCL_ARTIFACTS_TO_SOURCE=false
export GCL_HOME="${XDG_CONFIG_HOME}"
{{/if}}

{{#if (is_executable "go") }}
export GOPATH="${XDG_DATA_HOME}/go"
export PATH="${GOPATH}/bin${PATH:+:}${PATH}"
{{/if}}

{{#if (is_executable "gpg") }}
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
{{/if}}

{{#if (is_executable "grip") }}
export GRIPHOME="${XDG_CONFIG_HOME}/grip"
{{/if}}

{{#if (is_executable "guix") }}
export GUIX_PROFILE="${XDG_CONFIG_HOME}/guix/current"
export GUIX_LOCPATH="${GUIX_PROFILE}/lib/locale"
export PATH="${GUIX_PROFILE}/bin${PATH:+:}${PATH}"
{{/if}}

{{#if (is_executable "node") }}
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
{{/if}}

{{#if (is_executable "npm") }}
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export PATH="${XDG_DATA_HOME}/npm/bin${PATH:+:}${PATH}"
{{/if}}

{{#if (is_executable "nu") }}
export NUPM_HOME="${XDG_DATA_HOME}/nupm"
{{/if}}

{{#if (is_executable "nvim") }}
export EDITOR=nvim
{{/if}}

{{#if (is_executable "python") }}
export PYTHON_HISTORY="${XDG_CACHE_HOME}/python/history"
{{/if}}

{{#if (is_executable "regctl") }}
export REGCTL_CONFIG="${XDG_CONFIG_HOME}/regctl/config.json"
{{/if}}

{{#if (is_executable "rustup") }}
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
{{/if}}

{{#if (is_executable "tsc") }}
export TS_NODE_HISTORY="${XDG_STATE_HOME}/ts_node_repl_history"
{{/if}}
