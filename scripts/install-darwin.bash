#!/usr/bin/env bash

# Wrap everything into a {} so that bash will only execute once everything has been read (i.e.
# downloaded)
{
set -eu
set -o pipefail

# Change to repository root
cd "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/../";
source scripts/common.bash

is_os_darwin() {
    if [ "$(uname -s)" = "Darwin" ]; then
        return 0
    else
        return 1
    fi
}


if ! is_os_darwin; then
    failure "This script is intended for use on MacOS"
fi

if [ -z "$USER" ] && ! USER=$(id -u -n); then
    failure "\$USER is not set"
fi

if [ -z "$HOME" ]; then
    failure "\$HOME is not set"
fi

if ! xcode-select -p 1>/dev/null; then
    failure "commandline-tools are not installed. Install with 'xcode-select --install'"
fi

if ! command -v nix 1>/dev/null; then
    failure "nix not installed. Install with 'sh <(curl -L https://nixos.org/nix/install) --daemon'"
fi

ok "Ready to install!"

}
# End of {} wrapping for download protection
