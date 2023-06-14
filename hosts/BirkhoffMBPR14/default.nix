{ config, pkgs, lib, ... }:

let

  username = "birkhoff";
  hostname = "BirkhoffMBPR14";

in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./home;
  };

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
  };

  # Allow installing packages with unfree licenses
  nixpkgs.config.allowUnfree = true;

  imports = [
    (
      import ./os-settings.nix (
        { inherit hostname; }
      )
    )
    ./packages/homebrew.nix
    ./packages/system-packages.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.settings.auto-optimise-store = true;

  # Enable flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin
  '';

  # Load nix-darwin in /etc/zshrc.
  programs.zsh.enable = true;

  system.activationScripts = {
    "preUserActivation".text = ''
      if ! /usr/bin/pgrep -q oahd >/dev/null 2>&1; then
        echo "[+] Installing Rosetta"
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
      fi

      if ! [[ -f "/opt/homebrew/bin/brew" ]] && ! [[ -f "/usr/local/bin/brew" ]]; then
        echo "[+] Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
