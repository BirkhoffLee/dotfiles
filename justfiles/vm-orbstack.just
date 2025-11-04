# justfile for Orbstack + NixOS VM management

orbctlPath := "/usr/local/bin/orbctl"
machineName := "nixos"
image := "nixos:25.05"

# Create the OrbStack VM
[group('orbstack')]
orb-create:
  #!/usr/bin/env bash
  if {{orbctlPath}} list | grep -q "{{machineName}}"; then
    echo "Error: Machine {{machineName}} already exists."
    exit 1
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
  {{orbctlPath}} run sudo cp -r {{FLAKES_PATH}} /nix-config
  @echo "Installing git..."
  {{orbctlPath}} run sudo env NIX_CONFIG="experimental-features = nix-command flakes" nix profile install nixpkgs#git
  @echo "Applying NixOS configuration..."
  {{orbctlPath}} run sudo env NIX_CONFIG="experimental-features = nix-command flakes" {{NH_COMMAND}} os switch --bypass-root-check --hostname nixos-vm-aarch64 /nix-config -- --accept-flake-config
  @echo "NixOS configuration completed."
