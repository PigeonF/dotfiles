#!/usr/bin/env -S just --justfile

set shell := ["bash", "-uc"]
set export

alias b := build
alias s := switch

log := "warn"
export JUST_LOG := log

_default:
  @just --justfile {{ justfile() }} --list

build:
  {{if os() == "linux" { "nixos"  } else { "darwin"  } }}-rebuild build --verbose --print-build-logs --show-trace --flake .

switch:
  {{if os() == "linux" { "sudo nixos"  } else { "darwin"  } }}-rebuild switch --verbose --print-build-logs --show-trace --flake .

hm:
  home-manager switch --verbose --print-build-logs --show-trace --flake .
