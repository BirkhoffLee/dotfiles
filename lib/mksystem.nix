{
  nixpkgs,
  overlays,
  inputs,
}:

name:
{
  system,
  user,
  darwin ? false,
  wsl ? false,
}:

let
  # True if this is a WSL system.
  isWSL = wsl;

  # True if Linux, which is a heuristic for not being Darwin.
  isLinux = !darwin && !isWSL;

  # The config files for this system.
  # Host configs are in hosts/${name}/ and will auto-import default.nix
  machineConfig = ../hosts/${name};
  # Shared home-manager config at the root
  userHMConfig = ../home;

  # NixOS vs nix-darwin functions
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager =
    if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc rec {
  inherit system;

  specialArgs = { inherit inputs; };

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    { nixpkgs.overlays = overlays; }

    # Allow unfree packages.
    { nixpkgs.config.allowUnfree = true; }

    # Bring in WSL if this is a WSL build
    (if isWSL then inputs.nixos-wsl.nixosModules.wsl else { })

    # Machine-specific configuration
    machineConfig

    # Home-manager integration
    home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.${user} = import userHMConfig;
    }

    # nix-index-database integration
    inputs.nix-index-database.${if darwin then "darwinModules" else "nixosModules"}.nix-index
    { programs.nix-index-database.comma.enable = true; }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        isWSL = isWSL;
        inputs = inputs;
      };
    }
  ];
}
