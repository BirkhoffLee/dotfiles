# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform Nix configuration repository supporting both **macOS** (via nix-darwin) and **NixOS**, using Nix flakes for reproducible system configuration. The setup uses a shared home-manager configuration that works across all systems.

**Current hosts:**
- `AlexMBP`: macOS (M1 Pro, Sequoia) - nix-darwin
- `nixos-vm-aarch64`: NixOS (aarch64-linux) - VMware Fusion VM
- `nixos-orbstack`: NixOS (aarch64-linux) - OrbStack VM

**Current user:** `ale`

## Architecture

### Repository Structure

```
.
├── flake.nix              # Main flake configuration
├── lib/
│   └── mksystem.nix       # Helper function to create system configurations
├── hosts/                 # System-specific configurations
│   ├── AlexMBP/          # macOS host (nix-darwin)
│   │   ├── default.nix   # System configuration
│   │   ├── os-settings.nix
│   │   └── packages/
│   ├── nixos-vm-aarch64/       # VMware Fusion NixOS VM
│   │   └── default.nix   # System configuration
│   ├── nixos-orbstack/   # OrbStack NixOS VM
│   │   └── default.nix   # System configuration
│   ├── shared-nix-settings.nix  # Shared Nix daemon settings
│   └── gui-vm-shared.nix        # Shared GUI VM configuration
├── home/                  # Shared home-manager configuration
│   ├── default.nix        # Main home config (platform-agnostic)
│   ├── programs/          # Program-specific configs (auto-imported)
│   ├── files/             # Config files (auto-imported)
│   ├── packages/          # User packages
│   └── libs/              # Helper libraries
└── justfiles/             # Modular just recipes
    ├── vm-vmware-fusion.just  # VMware Fusion VM management
    └── vm-orbstack.just       # OrbStack VM management
```

### Flake Structure

The repository uses a flake-based architecture defined in `flake.nix`:

- **Multiple nixpkgs channels**: `nixpkgs-master`, `nixpkgs-stable` (25.05-darwin), and `nixpkgs-unstable`
- **Overlays system**: Provides access to different package versions and custom packages
  - `pkgs-master`, `pkgs-stable`, `pkgs-unstable`: Different nixpkgs versions
  - `apple-silicon`: Provides x86_64 packages on aarch64-darwin via `pkgs-x86`
  - `zellij-plugins`: Custom Zellij plugins (zjstatus, zjstatus-hints, zj-quit)
  - `fonts`: Custom fonts including Berkeley Mono (requires secrets) and Commit Mono NF
  - `tweaks`: Temporary overrides placeholder
- **lib/mksystem.nix**: Helper function that simplifies creating system configurations for both Darwin and NixOS

### Configuration Philosophy

**Separation of Concerns:**
1. **System-level** (`hosts/<hostname>/default.nix`): OS-specific configuration (nix-darwin or NixOS)
2. **User-level** (`home/default.nix`): Shared home-manager configuration, platform-agnostic

The `lib/mksystem.nix` helper abstracts away the differences between Darwin and NixOS configurations, automatically:
- Selecting the correct system function (darwinSystem vs nixosSystem)
- Applying overlays and nixpkgs configuration
- Integrating home-manager with correct modules
- Integrating nix-index-database
- Passing special arguments to modules

### Home Configuration (`home/`)

The home-manager configuration is **shared across all hosts** and platform-agnostic:
- Automatically imports all `.nix` files from `./programs/` and `./files/`
- Uses `pkgs.stdenv.isDarwin` to conditionally enable macOS-specific features
- Session PATH configuration for Rust, Go, Python (uv), and platform-specific paths
- Platform-specific activation scripts (e.g., macOS wallpaper, Library visibility)

### Host Configurations

**AlexMBP** (`hosts/AlexMBP/default.nix`):
- nix-darwin system configuration
- System packages and Homebrew integration
- macOS-specific OS settings and network configuration
- Activation scripts (Rosetta installation, Homebrew setup, locate database)

**nixos-vm-aarch64** (`hosts/nixos-vm-aarch64/default.nix`):
- NixOS system configuration for VMware Fusion
- Basic bootloader and filesystem configuration
- NixOS-specific settings (networking, SSH, systemd)

**nixos-orbstack** (`hosts/nixos-orbstack/default.nix`):
- NixOS system configuration for OrbStack
- Similar to nixos-vm-aarch64 but optimized for OrbStack environment

### Package Management Strategy

**Nix packages** are used for:
- CLI tools and development utilities
- System-level configuration
- Declarative management

**Homebrew** (`hosts/AlexMBP/packages/homebrew.nix`) is used for:
- GUI applications (they self-update and conflict with Nix immutability)
- Mac App Store apps (via `mas`)
- Some specialized tools (displayplacer, borgbackup-fuse)

## Common Development Commands

### Building and Switching Configurations

Using `just` (preferred):
```bash
just switch          # Build and switch to new configuration (alias: just s)
just switch-fast     # Switch without network access (alias: just sf)
just update          # Update all flake inputs and commit lock file (alias: just u)
just update-input <name>  # Update specific flake input (alias: just ui)
just format          # Format all Nix files using nixfmt-tree
just clean           # Clean old generations and optimize store
```

Using `nh` directly:
```bash
nh darwin switch --hostname AlexMBP "$HOME/.config/dotfiles"
nh darwin switch --update --hostname AlexMBP "$HOME/.config/dotfiles"
nh darwin switch --update-input <name> --hostname AlexMBP "$HOME/.config/dotfiles"
nh clean all
```

Legacy Makefile commands:
```bash
make all     # Equivalent to: sudo darwin-rebuild switch --flake ".#AlexMBP"
make repair  # Garbage collect and verify/repair Nix store
```

### Testing Configuration Changes

Before switching (macOS):
```bash
nix build ".#darwinConfigurations.AlexMBP.system" --show-trace
```

For NixOS (evaluation only from macOS):
```bash
nix eval ".#nixosConfigurations.nixos-vm-aarch64.config.system.name"
nix eval ".#nixosConfigurations.nixos-orbstack.config.system.name"
```

After switching, verify services are running correctly and check for any activation errors.

### VM Management

**VMware Fusion VM** (`justfiles/vm-vmware-fusion.just`):
```bash
# Bootstrap a fresh NixOS ISO (run once with root password 'root')
just vm-bootstrap0 <ip-address>

# Finalize installation (copy config, switch, setup secrets)
just vm-bootstrap <ip-address>

# SSH into the VM
just vm-ssh           # as user 'ale'
just vm-ssh root      # as root

# Sync dotfiles to VM
NIXADDR=<ip> just vm-sync

# Rebuild NixOS on VM
NIXADDR=<ip> just vm-switch
```

**OrbStack VM** (`justfiles/vm-orbstack.just`):
```bash
# Create OrbStack VM
just orb-create

# Configure NixOS on OrbStack VM
just orb-configure

# Remove OrbStack VM
just orb-remove
```

Environment variables for VMware VM commands:
- `NIXADDR`: VM IP address (required)
- `NIXPORT`: SSH port (default: 22)
- `NIXUSER`: SSH user (default: ale)

## File Organization Patterns

### Adding New Programs to Home Configuration

1. Create `home/programs/<program>.nix`
2. The file is automatically imported by `home/default.nix`
3. Configure using home-manager options
4. Use `lib.mkIf pkgs.stdenv.isDarwin { ... }` for macOS-specific settings
5. Use `lib.mkIf pkgs.stdenv.isLinux { ... }` for Linux-specific settings

Example:
```nix
{ pkgs, lib, ... }:
{
  programs.myprogram = {
    enable = true;
    # Shared settings
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    # macOS-specific settings
  };
}
```

### Adding Shell Configuration

1. Create `home/files/<config>.nix` for static files
2. Create `home/files/shell/<name>.zsh` for shell scripts
3. Files are automatically imported by `home/default.nix`

### Adding Custom Packages

1. **System packages** (OS-specific): Edit `hosts/<hostname>/packages/system-packages.nix`
2. **User packages** (shared): Edit `home/packages/user-packages.nix`
3. **Homebrew apps** (macOS only): Edit `hosts/AlexMBP/packages/homebrew.nix`
4. **Custom derivations**: Create in `packages/` directory and add to overlays in `flake.nix`

### Adding a New Host

1. Create `hosts/<hostname>/default.nix`
2. Add system-specific configuration (Darwin or NixOS)
3. Use `currentSystemUser` parameter (provided by mksystem.nix) instead of hardcoding username
4. Consider importing shared configuration files:
   - `shared-nix-settings.nix`: Common Nix daemon settings
   - `gui-vm-shared.nix`: Shared GUI VM configuration (for NixOS VMs with desktop)
5. Add to `flake.nix`:
   ```nix
   # For macOS
   darwinConfigurations.<hostname> = mkSystem "<hostname>" {
     system = "aarch64-darwin";  # or "x86_64-darwin"
     user = "ale";
     darwin = true;
   };

   # For NixOS
   nixosConfigurations.<hostname> = mkSystem "<hostname>" {
     system = "aarch64-linux";  # or "x86_64-linux"
     user = "ale";
   };
   ```

## Important Implementation Details

### Justfile Architecture

The repository uses a modular `justfile` system where the main `justfile` at the root imports specialized recipe files from `justfiles/`:

- Main `justfile`: Core commands (switch, update, format, clean)
- `justfiles/vm-vmware-fusion.just`: VMware Fusion VM management recipes
- `justfiles/vm-orbstack.just`: OrbStack VM management recipes

When adding new VM-related or specialized commands, create a new `.just` file in `justfiles/` and import it in the main `justfile` using `import 'justfiles/<name>.just'`.

### Overlay System

When adding packages from different nixpkgs versions, use the overlay system:
- `pkgs-master.<package>` for bleeding-edge packages
- `pkgs-stable.<package>` for stable releases
- `pkgs-unstable.<package>` for unstable but tested packages
- `pkgs-x86.<package>` for x86_64 packages on Apple Silicon

### Secrets Management

A private `dotfiles.secret` repository is referenced in `flake.nix`:
```nix
secrets = {
  url = "git+ssh://git@github.com/BirkhoffLee/dotfiles.secret.git?ref=main&shallow=1";
  flake = false;
};
```

This is used for sensitive files like proprietary fonts (Berkeley Mono). Access requires proper SSH credentials.

### Activation Scripts

The system uses activation scripts at multiple levels:

**System-level** (e.g., `hosts/AlexMBP/default.nix` for macOS):
- `preActivation`: Rosetta installation, Homebrew installation
- `postActivation`: Enable locate database, reveal /Volumes

**Home-level** (`home/default.nix`):
- macOS-specific (wrapped in `lib.mkIf isDarwin`):
  - `revealHomeLibraryDirectory`: Make ~/Library visible
  - `setWallpaper`: Download and set Raycast wallpaper
  - `activateUserSettings`: Restart macOS services to apply settings

Order matters: home-manager activation scripts use `lib.hm.dag.entryAfter` to ensure correct sequencing.

### Shell Configuration

The shell setup uses several specialized files (all under `home/files/shell/`):
- `home/files/shell/functions.zsh`: Custom functions (shrinkvid, impaste, timer, aic)
- `home/files/shell/fzf.zsh`: fzf-tab configuration with smart previews
- `home/files/shell/proxy.zsh`: Auto-propagated proxy settings
- `home/files/shell/completions.zsh`: Custom completions
- `home/files/shell/options.zsh`: Zsh options
- `home/files/shell/colors.zsh`: Color definitions

These are sourced in `home/programs/zsh.nix`.

### Development Environments

As noted in the README: "Development Environments should be managed using nix-shell" rather than installing development tools globally. Use `nix-shell -p <packages>` for temporary environments or create `shell.nix` files for projects.

The `nix-index-database` and `comma` are configured to help locate and run commands without installation.

## Configuration Philosophy

1. **Declarative over imperative**: All system configuration should be in Nix files
2. **Cross-platform by default**: Home configuration works on both macOS and NixOS
3. **Separation of concerns**: System config in `hosts/`, user config in `home/`
4. **Immutability**: Prefer Nix packages; use Homebrew only for GUI apps that self-update (macOS only)
5. **Reproducibility**: Pin inputs in `flake.lock`, commit after updates
6. **Modularity**: Separate concerns into individual `.nix` files that are auto-imported
7. **Version flexibility**: Use overlays to access packages from different nixpkgs channels
8. **Platform awareness**: Use `pkgs.stdenv.isDarwin` and `pkgs.stdenv.isLinux` for platform-specific config

## Troubleshooting

### After macOS Updates

Follow the process in README.md lines 96-120:
1. Upgrade Xcode CLI tools
2. May need to uninstall and reinstall Nix
3. System restart may be required
4. Fix SSL certs if needed
5. Review nix-darwin CHANGELOG

### Nix Store Issues

```bash
make repair  # Garbage collect and verify/repair
```

### Build Failures

Add `--show-trace` flag to see detailed error information:
```bash
just switch --show-trace
```
