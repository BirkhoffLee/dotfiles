#!/usr/bin/env just --justfile

default:
  @just --list

format:
  nix run nixpkgs#nixfmt-tree

alias s := switch

switch:
  nix run nixpkgs#nh darwin switch --show-trace

alias sf := switch-fast

switch-fast:
  nix run nixpkgs#nh darwin switch --show-trace --offline

# Update all the flake inputs
alias u := update
update:
  nix flake update --commit-lock-file

# Update specific input
# Usage: just upp nixpkgs
alias ui := update-input
update-input input:
  nix flake update {{input}} --commit-lock-file

clean:
  nix run nixpkgs#nh clean all

clean-and-optimize:
  nix run nixpkgs#nh clean all --optimise
