#!/usr/bin/env bash

readonly ESC='\033[0m'
readonly GREEN='\033[32m'
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
