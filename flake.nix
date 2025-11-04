{
  description = "birkhoff's dotfiles";

  nixConfig = {
    # Merged with the system-level substituters.
    # This config is included to speed up the initial build.
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://birkhoff.cachix.org"
      "https://mitchellh-nixos-config.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "birkhoff.cachix.org-1:m7WmdU7PKc6fsKedC278lhLtiqjz6ZUJ6v2nkVGyJjQ="
      "mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="
    ];
  };

  inputs = {
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Some other packages
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # _1password-shell-plugins.url = "github:1Password/shell-plugins";
    helix.url = "github:helix-editor/helix/master";

    # Zellij stuff
    zjstatus.url = "github:dj95/zjstatus";
    zjstatus-hints.url = "github:b0o/zjstatus-hints";
    zj-quit.url = "github:dj95/zj-quit";

    secrets = {
      url = "git+ssh://git@github.com/BirkhoffLee/dotfiles.secret.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    # https://github.com/malob/nixpkgs/blob/61d4809925a523296278885ff8a75d3776a5c813/flake.nix#L34
    let
      inherit (inputs.nixpkgs-unstable.lib) attrValues optionalAttrs singleton;

      # Overlays configuration
      overlaysList =
        attrValues self.overlays
        ++ singleton (
          final: prev:
          (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Sub in x86 version of packages that don't build on Apple Silicon.
            inherit (final.pkgs-x86)
              agda
              idris2
              ;
          })
          // {
            # Add other overlays here if needed.
          }
        );

      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
        overlays = overlaysList;
      };

      # Helper function to create system configurations
      mkSystem = import ./lib/mksystem.nix {
        nixpkgs = inputs.nixpkgs-unstable;
        overlays = overlaysList;
        inherit inputs;
      };
    in
    {
      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        apple-silicon =
          _: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Add access to x86 packages system is running Apple Silicon
            pkgs-x86 = import inputs.nixpkgs-unstable {
              system = "x86_64-darwin";
              inherit (nixpkgsDefaults) config;
            };
          };

        rust = inputs.rust-overlay.overlays.default;

        zellij-plugins = _: prev: {
          zjstatus = inputs.zjstatus.packages.${prev.system}.default;
          zjstatus-hints = inputs.zjstatus-hints.packages.${prev.system}.default;
          zj-quit = inputs.zj-quit.packages.${prev.system}.default;
        };

        fonts =
          _: prev: with _; {
            berkeley-mono = callPackage ./packages/fonts/berkeley-mono.nix { secrets = inputs.secrets; };
            commit-mono-nf = callPackage ./packages/fonts/commit-mono-nf.nix { };
          };

        tweaks = _: _: {
          # Add temporary overrides here
        };
      };

      darwinConfigurations = {
        AlexMBP = mkSystem "AlexMBP" {
          system = "aarch64-darwin";
          user = "ale";
          darwin = true;
        };
      };

      nixosConfigurations = {
        nixos-vm-aarch64 = mkSystem "nixos-vm-aarch64" {
          system = "aarch64-linux";
          user = "ale";
        };

        nixos-orbstack = mkSystem "nixos-orbstack" {
          system = "aarch64-linux";
          user = "ale";
        };
      };
    };
}
