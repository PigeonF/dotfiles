#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# First check that nix develop works
nix develop "$@" --command true

while IFS='=' read -r -d '' name value; do
    export "$name"="$value"
done < <(nix develop "$@" --command env -0)
