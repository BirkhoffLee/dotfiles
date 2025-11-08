# justfile for Orbstack + NixOS VM management

orbctlPath := "/usr/local/bin/orbctl"
machineName := "nixos"
image := "nixos:25.05"

# Create the OrbStack VM
[group('orbstack')]
orb-create:
  #!/usr/bin/env bash
  if {{orbctlPath}} list | grep -q "{{machineName}}"; then
    echo "Machine {{machineName}} already exists."
  else
    echo "Creating {{image}} machine \"{{machineName}}\"..."
    {{orbctlPath}} create {{image}} {{machineName}}
    echo "Machine "{{machineName}}" created successfully."
  fi

# Remove the OrbStack VM
[group('orbstack')]
orb-remove:
  #!/usr/bin/env bash
  if {{orbctlPath}} list | grep -q "{{machineName}}"; then
    echo "Removing machine: {{machineName}}..."
    {{orbctlPath}} delete {{machineName}} -f
    echo "Machine {{machineName}} removed successfully."
  else
    echo "Error: Machine {{machineName}} does not exist."
  fi

# Configure NixOS on the OrbsStack VM
[group('orbstack')]
orb-configure:
  @echo "Running configuration on the VM using orbctl run..."
  @echo "Installing git if not present..."
  {{orbctlPath}} run sudo sh -c 'command -v git >/dev/null 2>&1 || env NIX_CONFIG="experimental-features = nix-command flakes" nix profile install nixpkgs#git'
  @echo "Importing GitHub SSH public key..."
  {{orbctlPath}} run sh -c 'grep -q "github.com ssh-ed25519" $HOME/.ssh/known_hosts 2>/dev/null || echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl" >> $HOME/.ssh/known_hosts'
  @echo "Applying NixOS configuration..."
  {{orbctlPath}} run {{NH_COMMAND}} os switch --hostname nixos-orbstack {{FLAKES_PATH}} -- --accept-flake-config --impure
  @echo "NixOS configuration completed."
