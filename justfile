#!/usr/bin/env just --justfile

# Use bash for better shell features
set shell := ["bash", "-cu"]

# Connectivity info for Linux VM
# `NIXADDR=1.2.3.4 just task`
NIXADDR := env_var_or_default("NIXADDR", "unset")
NIXPORT := env_var_or_default("NIXPORT", "22")
NIXUSER := env_var_or_default("NIXUSER", "ale")

HOSTNAME := env_var_or_default("HOSTNAME", "AlexMBP")

# Get the path to this directory
FLAKES_PATH := justfile_directory()

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS := "-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
SSH_OPTIONS_WITH_PUBKEY := "-o PubkeyAuthentication=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

default:
  @echo "Runtime Variables:"
  @echo "    NIXADDR={{NIXADDR}}"
  @echo "    NIXPORT={{NIXPORT}}"
  @echo "    NIXUSER={{NIXUSER}}"
  @echo "    SSH_OPTIONS={{SSH_OPTIONS}}"
  @echo "    FLAKES_PATH={{FLAKES_PATH}}"
  @echo ""
  @just --list

format:
  nix run nixpkgs#nixfmt-tree

alias s := switch

switch:
  nix run nixpkgs#nh -- darwin switch --show-trace

alias sf := switch-fast

switch-fast:
  nix run nixpkgs#nh -- darwin switch --show-trace --offline

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
  nix run nixpkgs#nh -- clean all

clean-and-optimize:
  nix run nixpkgs#nh -- clean all --optimise

cache-darwin:
  nix build '.#darwinConfigurations.AlexMBP.config.system.build.toplevel' --json \
    | jq -r '.[].outputs | to_entries[].value' \
    | cachix push birkhoff

# vm-bootstrap0: Partition, format, generate config, enable SSH, install, reboot.
# Run on a fresh NixOS ISO with root password set to 'root'.
vm-bootstrap0:
  ssh {{SSH_OPTIONS}} -p{{NIXPORT}} root@{{NIXADDR}} " \
    parted /dev/nvme0n1 -- mklabel gpt; \
    parted /dev/nvme0n1 -- mkpart primary 512MB -8GB; \
    parted /dev/nvme0n1 -- mkpart primary linux-swap -8GB 100\%; \
    parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB; \
    parted /dev/nvme0n1 -- set 3 esp on; \
    sleep 1; \
    mkfs.ext4 -L nixos /dev/nvme0n1p1; \
    mkswap -L swap /dev/nvme0n1p2; \
    mkfs.fat -F 32 -n boot /dev/nvme0n1p3; \
    sleep 1; \
    mount /dev/disk/by-label/nixos /mnt; \
    mkdir -p /mnt/boot; \
    mount /dev/disk/by-label/boot /mnt/boot; \
    nixos-generate-config --root /mnt; \
    sed --in-place '/system\\.stateVersion = .*/a \
      nix.package = pkgs.nixVersions.latest;\\n \
      nix.extraOptions = \"experimental-features = nix-command flakes\";\\n \
      nix.settings.substituters = [\"https://birkhoff.cachix.org\"];\\n \
      nix.settings.trusted-public-keys = [\"birkhoff.cachix.org-1:m7WmdU7PKc6fsKedC278lhLtiqjz6ZUJ6v2nkVGyJjQ=\"];\\n \
      environment.systemPackages = [ pkgs.git ];\\n \
      services.openssh.enable = true;\\n \
      services.openssh.knownHosts = { github = { hostNames = [\"github.com\"]; publicKey = \"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl\"; }; };\\n \
      services.openssh.settings.PasswordAuthentication = true;\\n \
      services.openssh.settings.PermitRootLogin = \"yes\";\\n \
      users.users.root.openssh.authorizedKeys.keys = [\"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0762tms0QT6kCQ7tTgoOdm+ry29ImKgDk09hXurEfM\"];\\n \
      users.users.root.initialPassword = \"root\";\\n \
    ' /mnt/etc/nixos/configuration.nix; \
    nixos-install --no-root-passwd && reboot; \
  "

# Copy Ghostty's terminfo entry to the remote machine
vm-ssh-root:
  infocmp -x xterm-ghostty | ssh {{SSH_OPTIONS_WITH_PUBKEY}} -p {{NIXPORT}} root@{{NIXADDR}} -- tic -x -
  ssh {{SSH_OPTIONS_WITH_PUBKEY}} -p {{NIXPORT}} root@{{NIXADDR}}

vm-ssh:
  infocmp -x xterm-ghostty | ssh {{SSH_OPTIONS_WITH_PUBKEY}} -p {{NIXPORT}} {{NIXUSER}}@{{NIXADDR}} -- tic -x -
  ssh {{SSH_OPTIONS_WITH_PUBKEY}} -p {{NIXPORT}} {{NIXUSER}}@{{NIXADDR}}

# copy our secrets into the VM
# SSH keys
vm-secrets:
  op read "op://Personal/id_ed25519/id_ed25519" | ssh {{SSH_OPTIONS_WITH_PUBKEY}} {{NIXUSER}}@{{NIXADDR}} 'umask 077 && mkdir -p ~/.ssh && cat > ~/.ssh/id_ed25519 && chmod 600 ~/.ssh/id_ed25519'

# vm-copy: rsync repository to /nix-config on the VM via sudo rsync
vm-copy:
  rsync -av -e 'ssh {{SSH_OPTIONS_WITH_PUBKEY}} -p{{NIXPORT}}' \
    --exclude='.git/' \
    --rsync-path="sudo rsync" \
    "{{FLAKES_PATH}}/" "{{NIXUSER}}@{{NIXADDR}}:/nix-config"

# vm-switch: nixos-rebuild switch on the VM (requires vm-copy first)
vm-switch:
  ssh {{SSH_OPTIONS_WITH_PUBKEY}} -p{{NIXPORT}} {{NIXUSER}}@{{NIXADDR}} " \
    ulimit -n 65536 && NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nix run nixpkgs#nh -- os switch --bypass-root-check --hostname {{HOSTNAME}} /nix-config \
  "
# ssh {{SSH_OPTIONS_WITH_PUBKEY}} -p{{NIXPORT}} {{NIXUSER}}@{{NIXADDR}} " \
#   ulimit -n 65536 && sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake \"/nix-config#{{HOSTNAME}}\" \
# "

# vm-bootstrap: finalize a freshly installed VM (copy, switch, secrets, reboot)
vm-bootstrap:
  NIXUSER=root just vm-secrets
  NIXUSER=root just vm-copy
  NIXUSER=root just vm-switch
  ssh {{SSH_OPTIONS}} -p{{NIXPORT}} {{NIXUSER}}@{{NIXADDR}} " \
    sudo rm -f /root/.ssh/id_ed25519 && sudo reboot; \
  "
