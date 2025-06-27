{ pkgs }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://misc-assets.raycast.com/wallpapers/loupe-mono-dark.heic";
    sha256 = "sha256-MwvRU7U4tO6F1duxBrHLOd7F5Gnzv/zyiZkm5EFqkY4=";
  };
in
pkgs.writeShellScriptBin "set-wallpaper-script" ''
  set -e
  /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"${wallpaper}\""
''
