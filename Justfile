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
  nixos-rebuild build --verbose --print-build-logs --show-trace --flake .

switch:
  nixos-rebuild switch --verbose --print-build-logs --show-trace --flake .

hm TARGET="":
  home-manager switch --verbose --print-build-logs --show-trace --flake .{{ if TARGET == "" { "" } else { "#" + TARGET } }}
