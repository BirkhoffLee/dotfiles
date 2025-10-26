{
  description = "birkhoff's dotfiles";

  inputs = {
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # stylix.url = "github:nix-community/stylix";
    # stylix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Some other packages
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # _1password-shell-plugins.url = "github:1Password/shell-plugins";
    # helix.url = "github:helix-editor/helix/25.07.1";

    # Zellij stuff
    zjstatus.url = "github:dj95/zjstatus";
    zjstatus-hints.url = "github:b0o/zjstatus-hints";
    zj-quit.url = "github:dj95/zj-quit";
  };

  outputs =
    {
      self,
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

        zellij-plugins = _: prev: {
          zjstatus = inputs.zjstatus.packages.${prev.system}.default;
          zjstatus-hints = inputs.zjstatus-hints.packages.${prev.system}.default;
          zj-quit = inputs.zj-quit.packages.${prev.system}.default;
        };

        tweaks = _: _: {
          # Add temporary overrides here
        };
      };

      darwinConfigurations = {
        AlexMBP = inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/AlexMBP
            { nixpkgs = nixpkgsDefaults; }
            inputs.home-manager.darwinModules.home-manager
            inputs.nix-index-database.darwinModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
            # inputs.stylix.darwinModules.stylix
          ];
        };
      };
    };
}
