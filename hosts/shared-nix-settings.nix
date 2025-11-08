{ ... }:

{
  nix.settings = {
    # Common substituters shared across all hosts
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://birkhoff.cachix.org"
    ];

    # Common trusted public keys
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "birkhoff.cachix.org-1:m7WmdU7PKc6fsKedC278lhLtiqjz6ZUJ6v2nVGyJjQ="
    ];

    # Trusted users can use extra-substituters from flakes without warnings
    trusted-users = [
      "@admin"
      "root"
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Recommended when using `direnv` etc.
    keep-derivations = true;
    keep-outputs = true;
  };
}
