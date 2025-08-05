{
  description = "birkhoff's dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://birkhoff.cachix.org"
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "birkhoff.cachix.org-1:m7WmdU7PKc6fsKedC278lhLtiqjz6ZUJ6v2nkVGyJjQ="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };

  inputs = {
    # nixpkgs set
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment managers
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    {
      self,
      darwin,
      home-manager,
      nix-index-database,
      ...
    }@inputs:
    # https://github.com/malob/nixpkgs/blob/61d4809925a523296278885ff8a75d3776a5c813/flake.nix#L34
    let
      inherit (inputs.nixpkgs-unstable.lib) attrValues optionalAttrs singleton;

      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
        overlays =
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

        tweaks = _: _: {
          # Add temporary overrides here
        };
      };

      darwinConfigurations = {
        AlexMBP = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/AlexMBP
            { nixpkgs = nixpkgsDefaults; }
            home-manager.darwinModules.home-manager
            nix-index-database.darwinModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
          ];
        };
      };
    };
}
