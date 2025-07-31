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
    ./git.nix
    ./gnupg.nix
    ./helix.nix
    ./htop.nix
    ./hushlogin.nix
    ./llm.nix
    ./nano.nix
    ./tmux.nix
  ];
  
  # Expressions like $HOME are expanded by the shell.
  # However, since expressions like ~ or * are escaped,
  # they will end up in the PATH verbatim.
  #
  # @see https://nix-community.github.io/home-manager/options.xhtml#opt-home.sessionPath
  home.sessionPath = [
    # Note: Homebrew is loaded with `brew shellenv` in `zsh/default.nix`

    # Rust
    "${home.homeDirectory}/.cargo/bin"
    # Golang
    "${home.homeDirectory}/go/bin"
    # uv tool
    "${home.homeDirectory}/.local/bin"
    # Apple
    "/Library/Apple/usr/bin"
    # Wireshark
    "/Applications/Wireshark.app/Contents/MacOS"
  ];

  home.file = {
    ".shell".source = ./zsh/shell;
  };

  home.activation = {
    "revealHomeLibraryDirectory" = lib.hm.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/chflags nohidden "$HOME/Library"
    '';

    "setWallpaper" = lib.hm.dag.entryAfter ["revealHomeLibraryDirectory"] ''
      echo "[+] Setting wallpaper"
      ${setWallpaperScript}/bin/set-wallpaper-script
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
      '';
  };

  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
      settings = {
        ## Invert the UI - put the search bar at the top , Default to `false`
        invert = true;
        
        # Defaults to true. If enabled, upon hitting enter Atuin will immediately execute the command. Press tab to return to the shell and edit.
        enter_accept = false;

        ## Set this to true and Atuin will minimize motion in the UI - timers will not update live, etc.
        ## Alternatively, set env NO_MOTION=true
        prefers_reduced_motion = true;
      };
    };

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

    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };
  };
}
