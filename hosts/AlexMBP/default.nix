{ pkgs, lib, ... }:

let

  username = "ale";
  hostname = "AlexMBP";

in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = (import ./home);
  };

  system.primaryUser = "${username}";

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
  };

  imports = [
    ./packages/system-packages.nix
    (import ./os-settings.nix ({ inherit hostname; }))
    ./packages/homebrew.nix
  ];

  networking = {
    applicationFirewall = {
      enable = true;
      enableStealthMode = true;
      # allowSigned = true; # Whether to enable built-in software to receive incoming connections.
      # allowSignedApp = true; # Whether to enable downloaded signed software to receive incoming connections.
      # blockAllIncoming = true; # Whether to enable blocking all incoming connections.
    };
  };

  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  nix.settings = {
    # https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = false;

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Recommended when using `direnv` etc.
    keep-derivations = true;
    keep-outputs = true;
  };

  # Load nix-darwin in /etc/zshrc.
  programs.zsh.enable = true;

  # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/activation-scripts.nix#L83
  system.activationScripts = {
    "preActivation".text = ''
      if ! /usr/bin/pgrep -q oahd >/dev/null 2>&1; then
        echo "[+] Installing Rosetta"
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
      fi

      if ! [[ -f "/opt/homebrew/bin/brew" ]] && ! [[ -f "/usr/local/bin/brew" ]]; then
        echo "[+] Installing Homebrew"
        sudo -u ${username} /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';

    "postActivation".text = ''
      if ! sudo launchctl list | grep -q com.apple.locate; then
        echo "[+] Creating database for locate command"
        sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
      fi

      echo "[+] Revealing /Volumes"
      chflags nohidden /Volumes
    '';
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # https://github.com/LnL7/nix-darwin/blob/master/CHANGELOG
  system.stateVersion = 5;
}
