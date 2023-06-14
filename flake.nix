{
  description = "birkhoff's darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin }: {
    darwinConfigurations = {
      BirkhoffMBPR14 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/BirkhoffMBPR14
          home-manager.darwinModules.home-manager
        ];
      };
    };
  };
}
