{
  config,
  pkgs,
  lib,
  inputs,
  currentSystemUser,
  ...
}:

let
  username = currentSystemUser;
  hostname = "nixos-vm-aarch64";
in
{
  imports = [
    ./hardware-configuration.nix
    ../gui-vm-shared.nix
  ];

  # Setup qemu so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  # Networking
  networking.hostName = hostname;
  # networking.networkmanager.enable = true;

  # Interface is this on M1
  # networking.interfaces.ens160.useDHCP = true;

  # VMware Guest Tools
  virtualisation.vmware.guest.enable = true;

  # Share our host filesystem
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    # extraGroups = [ "wheel" "networkmanager" ];
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$NyO3jDlhxZvG1xEfAZ21i.$K2iEBoqfPs009g1mFI1Td8t00gd8/m.BIUSyFo9QqX9";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0762tms0QT6kCQ7tTgoOdm+ry29ImKgDk09hXurEfM"
    ];
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Install Firefox
  # programs.firefox.enable = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # helix
  # ghostty
}
