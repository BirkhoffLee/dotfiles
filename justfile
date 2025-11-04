#!/usr/bin/env just --justfile

# Use bash for better shell features
set shell := ["bash", "-cu"]

# Get the path to this directory
FLAKES_PATH := justfile_directory()

SSH_OPTIONS := "-o PubkeyAuthentication=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
NH_COMMAND := "env NIX_CONFIG=\"experimental-features = nix-command flakes\" nix run nixpkgs#nh --"
CACHIX_COMMAND := "op plugin run -- cachix"

import 'justfiles/vm-vmware-fusion.just'
import 'justfiles/vm-orbstack.just'

# Overview of justfile
default:
  @echo "Runtime Variables:"
  @echo "    NIXADDR={{NIXADDR}}"
  @echo "    NIXPORT={{NIXPORT}}"
  @echo "    NIXUSER={{NIXUSER}}"
  @echo "    SSH_OPTIONS={{SSH_OPTIONS}}"
  @echo "    FLAKES_PATH={{FLAKES_PATH}}"
  @echo ""
  @just --list

# Formats the entire repo using nixfmt
[group('code-quality')]
format:
  nix run nixpkgs#nixfmt-tree

alias s := switch
# Switch darwin configuration
[group('darwin')]
switch:
  {{NH_COMMAND}} darwin switch --show-trace

alias sf := switch-fast
# Switch darwin configuration with --offline flag
[group('darwin')]
switch-fast:
  {{NH_COMMAND}} darwin switch --show-trace --offline

alias o := optimize
# Frees up space by optimizing the Nix Store
[group('nix-misc')]
optimize:
  {{NH_COMMAND}} clean all

# Repairs the Nix Store
[group('nix-misc')]
repair:
  nix-store --verify --check-contents --repair

alias u := update
# Updates all the flake inputs
[group('flake')]
update:
  nix flake update --commit-lock-file

alias ui := update-input
# Updates a specific input. Usage: `just ui nixpkgs`
[group('flake')]
update-input input:
  nix flake update {{input}} --commit-lock-file

# Push darwin build artifacts to cachix
[group('cache')]
cache-darwin:
  nix build '.#darwinConfigurations.AlexMBP.config.system.build.toplevel' --json \
    | jq -r '.[].outputs | to_entries[].value' \
    | {{CACHIX_COMMAND}} push birkhoff

