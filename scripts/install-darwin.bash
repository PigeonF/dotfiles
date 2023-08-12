#!/usr/bin/env bash

# Wrap everything into a {} so that bash will only execute once everything has been read (i.e.
# downloaded)
{
set -eu
set -o pipefail

readonly ESC='\033[0m'
readonly BOLD='\033[1m'
readonly BLUE='\033[34m'
readonly BLUE_UL='\033[4;34m'
readonly GREEN='\033[32m'
readonly GREEN_UL='\033[4;32m'
readonly RED='\033[31m'

is_os_darwin() {
    if [ "$(uname -s)" = "Darwin" ]; then
        return 0
    else
        return 1
    fi
}

_textout() {
    echo -en "$1"
    shift
    if [ "$*" = "" ]; then
        cat
    else
        echo "$@"
    fi
    echo -en "$ESC"
}

ok() {
    _textout "$GREEN" "$@"
}

failure() {
    _textout "$RED" "$@"
    echo ""
    exit 1
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
