{
  # Homebrew has to be installed first.
  # This installs brew packages and Mac App Store apps.
  homebrew = {
    enable = true;

    brews = [
      "mas"
      # "carthage"
      "displayplacer"
      "hopenpgp-tools"
      "screenresolution"
      "borgbackup/tap/borgbackup-fuse"
    ];

    casks = [
      "imageoptim"
      "keka"
      "superwhisper"
      "menuwhere"
      "bloom"
      "betterdisplay"
      "brilliant"
      "lulu"
      "knockknock"
      "1password"
      "transmission"
      "1password-cli"
      "adoptopenjdk"
      "anki"
      "arc"
      "balenaetcher"
      "claude"
      "cursor"
      "deskpad"
      "discord"
      "dropbox"
      "figma"
      "ghostty"
      "google-chrome"
      "handbrake-app"
      "heynote"
      "iina"
      "imazing"
      "input-source-pro"
      "iterm2"
      "jordanbaird-ice"
      "key-codes"
      "keycastr"
      "macfuse"
      "mounty"
      "notion"
      "obs"
      "obsidian"
      "orbstack"
      "quicklook-csv"
      "quicklook-json"
      "quicklookapk"
      "raycast"
      "reader"
      "setapp"
      "shottr"
      "spotify"
      "steam"
      "sublime-text"
      "suspicious-package"
      "teamviewer"
      "telegram"
      "transmit"
      "utm"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "vorta"
      "wechat"
      "wifi-explorer"
      "winbox"
      "wireshark"
      "zed"
      "zoom"
    ];

    taps = [
      "borgbackup/tap"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Actions" = 1586435171;
      "AmorphousDiskMark" = 1168254295;
      "CrystalFetch" = 6454431289;
      "DaisyDisk" = 411643860;
      "Gifski" = 1351639930;
      "Goodnotes" = 1444383602;
      "Hyperduck" = 6444667067;
      "Infuse" = 1136220934;
      "Keynote" = 409183694;
      "LINE" = 539883307;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "NflxMultiSubs" = 1594059167;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Playlisty for Apple Music" = 1459275972;
      "Second Clock" = 6450279539;
      "Slack" = 803453959;
      "Tailscale" = 1475387142;
      "The Unarchiver" = 425424353;
      "WhatsApp" = 310633997;
      "WireGuard" = 1451685025;
      "Xcode" = 497799835;
      "Yoink" = 457622435;
    };
  };
}
