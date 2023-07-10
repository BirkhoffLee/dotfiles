{ pkgs, lib, ... }:

rec {
  home.stateVersion = "23.11";

  home.username = "birkhoff";
  home.homeDirectory = "/Users/${home.username}";

  imports = [
    ../packages/user-packages.nix
    (import ./zsh { inherit home pkgs; })
    (import ./ansible.nix { inherit home; })
    ./bundle.nix
    ./editorconfig.nix
    ./gem.nix
    ./git.nix
    ./gnupg.nix
    ./htop.nix
    ./hushlogin.nix
    ./mamba.nix
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

    "removeSomeDefaultDockIcons" = lib.hm.dag.entryAfter ["writeBoundary"] ''
      PLIST_PATH="${home.homeDirectory}/Library/Preferences/com.apple.dock.plist"
      for dockItemLabel in \
        "App Store" \
        "System Preferences" \
        Calendar \
        Contacts \
        Facetime \
        Freeform \
        Launchpad \
        Maps \
        Music \
        News \
        Notes \
        Photos \
        Podcasts \
        Reminders \
        Safari \
        TV ; do
        ${pkgs.dockutil}/bin/dockutil --find "$dockItemLabel" "$PLIST_PATH" > /dev/null 2>&1 \
          && echo "[+] Removing $dockItemLabel on Dock" \
          && ${pkgs.dockutil}/bin/dockutil --no-restart --remove "$dockItemLabel" "$PLIST_PATH"
      done
    '';

    "activateUserSettings" =
      lib.hm.dag.entryAfter ["revealHomeLibraryDirectory" "removeSomeDefaultDockIcons"] ''
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

        for app in \
          "cfprefsd" \
          "Dock" \
          "Finder" \
          "Mail" \
          "Photos" \
          "Safari" \
          "SystemUIServer" \
          "Activity Monitor"; do
          /usr/bin/killall "''${app}" &> /dev/null && echo "[+] Killed ''${app}" || true
        done
      '';
  };

  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
