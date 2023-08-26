#!/usr/bin/env bash

readonly ESC='\033[0m'
readonly BOLD='\033[1m'
readonly BLUE='\033[34m'
readonly BLUE_UL='\033[4;34m'
readonly GREEN='\033[32m'
readonly GREEN_UL='\033[4;32m'
readonly RED='\033[31m'

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
