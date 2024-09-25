#!/usr/bin/env -S just --justfile

set shell := ["bash", "-uc"]
set export

alias b := build
alias s := switch

log := "warn"
export JUST_LOG := log

_default:
  @just --justfile {{ justfile() }} --list

build: build-os build-hm

build-os:
  nixos-rebuild build --verbose --print-build-logs --show-trace --keep-going --flake .

build-hm TARGET="":
  home-manager build --verbose --print-build-logs --show-trace --flake .{{ if TARGET == "" { "" } else { "#" + TARGET } }}

switch: switch-os switch-hm

switch-os:
  nixos-rebuild switch --verbose --print-build-logs --show-trace --flake .

switch-hm TARGET="":
  home-manager switch --verbose --print-build-logs --show-trace --flake .{{ if TARGET == "" { "" } else { "#" + TARGET } }}
