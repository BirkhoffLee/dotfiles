{ pkgs, lib, ... }:

let
  setWallpaperScript = import ../wallpaper.nix { inherit pkgs; };
in
rec {
  home.stateVersion = "23.11";

  home.username = "ale";
  home.homeDirectory = "/Users/${home.username}";

  imports = [
    ../packages/user-packages.nix
    (import ./zsh { inherit home pkgs lib; })
    (import ./ansible.nix { inherit home; })
    ./1password.nix
    ./bundle.nix
    ./editorconfig.nix
    ./gem.nix
    ./ghostty.nix
    ./helix.nix
    ./git.nix
    ./gnupg.nix
    ./htop.nix
    ./hushlogin.nix
    ./nano.nix
    ./tmux.nix
  ];

  home.file = {
    ".shell".source = ./zsh/shell;
  };

  home.activation = {
    "revealHomeLibraryDirectory" = lib.hm.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/chflags nohidden "$HOME/Library"
    '';

    "activateUserSettings" =
      lib.hm.dag.entryAfter [ "setWallpaper" ] ''
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

        for app in \
          "Activity Monitor" \
          "cfprefsd" \
          "ControlStrip" \
          "Dock" \
          "Finder" \
          "Mail" \
          "Photos" \
          "replayd" \
          "Safari" \
          "SystemUIServer" \
          "TextInputMenuAgent" \
          "WindowManager"; do
          /usr/bin/killall "''${app}" &> /dev/null && echo "[+] Killed ''${app}" || true
        done

        # echo "[+] tailscaled install-system-daemon"
        # sudo ${pkgs.tailscale}/bin/tailscaled install-system-daemon
      '';
    "setWallpaper" = lib.hm.dag.entryAfter ["revealHomeLibraryDirectory"] ''
      echo "[+] Setting wallpaper"
      ${setWallpaperScript}/bin/set-wallpaper-script
    '';
  };

  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      # Use C-r and C-t from fzf
      # Note: C-r is later used for atuin history search
      # https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
