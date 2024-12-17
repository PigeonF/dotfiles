#!/usr/bin/env -S just --justfile

set shell := ["bash", "-uc"]
set export

alias b := build
alias s := switch

log := "warn"
export JUST_LOG := log

nixos := if os() == "macos" { "darwin" } else { "nixos" }

# _default:
#   @{{ quote(just_executable()) }} --justfile {{ quote(source_file()) }} --list

build: build-os build-hm

build-os:
  {{ nixos }}-rebuild build --verbose --print-build-logs --show-trace --keep-going --flake .

build-hm TARGET="":
  nix run nixpkgs#home-manager -- build --verbose --print-build-logs --show-trace --flake .{{ if TARGET == "" { "" } else { "#" + TARGET } }}

switch: switch-os switch-hm

switch-os:
  sudo {{ nixos }}-rebuild switch --verbose --print-build-logs --show-trace --flake .

switch-hm TARGET="":
  nix run nixpkgs#home-manager -- switch -b bak --verbose --print-build-logs --show-trace --flake .{{ if TARGET == "" { "" } else { "#" + TARGET } }}
