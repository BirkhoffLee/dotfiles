{ pkgs, lib, ... }:

let
  # List of all .nix files in ./programs
  programImports = builtins.map (file: ./programs/${file}) (
    builtins.filter (f: lib.hasSuffix ".nix" f) (builtins.attrNames (builtins.readDir ./programs))
  );

  # List of all .nix files in ./files
  fileImports = builtins.map (file: ./files/${file}) (
    builtins.filter (f: lib.hasSuffix ".nix" f) (builtins.attrNames (builtins.readDir ./files))
  );

  setWallpaperScript = import ./libs/wallpaper.nix { inherit pkgs; };
in
rec {
  home.stateVersion = "23.11";

  home.username = "ale";
  home.homeDirectory = "/Users/${home.username}";

  imports = [
    ./packages/user-packages.nix
    ./editorconfig.nix
  ]
  ++ programImports
  ++ fileImports;

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

  home.activation = {
    "revealHomeLibraryDirectory" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      /usr/bin/chflags nohidden "$HOME/Library"
    '';

    "setWallpaper" = lib.hm.dag.entryAfter [ "revealHomeLibraryDirectory" ] ''
      echo "[+] Setting wallpaper"
      ${setWallpaperScript}/bin/set-wallpaper-script
    '';

    "activateUserSettings" = lib.hm.dag.entryAfter [ "setWallpaper" ] ''
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

}
