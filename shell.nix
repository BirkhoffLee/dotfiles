let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable";
  pkgs = import nixpkgs {
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    just
    ssh-copy-id
    claude-code
    nh
    nixfmt-tree
    nixos-rebuild-ng
  ];

  NH_FLAKE = ".";
  # NIX_CONFIG = "experimental-features = nix-command flakes";
}
