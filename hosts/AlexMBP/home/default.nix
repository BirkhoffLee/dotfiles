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
    ./1password.nix
    ./ansible.nix
    ./bundle.nix
    ./editorconfig.nix
    ./gem.nix
    ./ghostty.nix
    ./git.nix
    ./gnupg.nix
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
      flags = [ "--disable-up-arrow" ];
      settings = {
        # Defaults to true. If enabled, upon hitting enter Atuin will immediately execute the command. Press tab to return to the shell and edit.
        enter_accept = false;

        ## Set this to true and Atuin will minimize motion in the UI - timers will not update live, etc.
        ## Alternatively, set env NO_MOTION=true
        prefers_reduced_motion = true;
      };
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "snazzy";
        
        editor = {
          mouse = false;
          auto-save = true;
          cursorline = true;
          line-number = "relative";
          statusline = {
            left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator"];
            right = ["version-control" "diagnostics" "selections" "register" "position" "position-percentage" "file-encoding"];
          };
        };
        
        keys.normal = {
          "Cmd-s" = ":write";
          "Cmd-b" = "page_up";
          "Cmd-f" = "page_down";
          "C-j" = "half_page_down";
          "C-k" = "half_page_up";
          "A-down" = ["extend_to_line_bounds" "delete_selection" "paste_after"];
          "A-up" = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
        };
        
        keys.insert = {
          "Cmd-s" = ":write";
          "Cmd-b" = "page_up";
          "Cmd-f" = "page_down";
        };
        
        keys.select = {
          "Cmd-s" = ":write";
          "Cmd-b" = "page_up";
          "Cmd-f" = "page_down";
        };
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "DELTA_FEATURES=decorations delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
          };

          commit = {
            signOff = true;
          };
        };
      };
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
