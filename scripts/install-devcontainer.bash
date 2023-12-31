#!/usr/bin/env bash

set -eu
set -o pipefail

# Change to repository root
cd "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/../";
source scripts/common.bash

if ! command -v nix 1>/dev/null; then
    failure "nix not installed. Install with 'sh <(curl -L https://nixos.org/nix/install) --daemon'"
fi

mkdir -p ~/.local/state/nix/profiles

nix run home-manager/release-23.11 -- switch --flake .#developer@devbox
