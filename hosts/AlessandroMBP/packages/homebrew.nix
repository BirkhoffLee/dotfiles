{
  # Homebrew has to be installed first.
  # This installs system-wide packages and Mac App Store apps.
  homebrew = {
    enable = true;

    brews = [
      "blueutil"
      # "carthage"
      "create-dmg"
      # "dex2jar"
      "displayplacer"
      "dns2tcp"
      "flarectl"
      "git-delta"
      "gnu-getopt"
      "gnu-sed"
      "gnu-tar"
      "hashpump"
      # "helm"
      "hopenpgp-tools"
      "testssl"
      "hydra"
      "icu4c@75"
      "knock"
      # "kubernetes-cli"
      "macvim"
      "mas"
      "ollama"
      "screenresolution"
      "tcptrace"
      "telnet"
      "tidy-html5"
      "whatmask"
      "ykman"
      "ykpers"
      "ameshkov/tap/dnslookup"
      "borgbackup/tap/borgbackup-fuse"
      "cjbassi/ytop/ytop"
    ];

    casks = [
      "1password-cli"
      "1password"
      "adoptopenjdk"
      "arc"
      "balenaetcher"
      "discord"
      "dropbox"
      "font-fira-code"
      "font-hack-nerd-font"
      "font-menlo-for-powerline"
      "font-source-code-pro"
      "google-chrome"
      "handbrake"
      "heynote"
      "iina"
      "imazing"
      "iterm2"
      "itsycal"
      "jordanbaird-ice"
      "key-codes"
      "macfuse"
      "mounty"
      "orbstack"
      "quicklook-csv"
      "quicklook-json"
      "quicklookapk"
      "raycast"
      "ghostty"
      "reader"
      "setapp"
      "spotify"
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
      "winbox"
      "wireshark"
      "zoom"
    ];

    taps = [
      "adoptopenjdk/openjdk"
      "ameshkov/tap"
      "birkhofflee/birkhoff"
      "borgbackup/tap"
      "bramstein/webfonttools"
      "buo/cask-upgrade"
      "cjbassi/ytop"
      "cloudflare/cloudflare"
      "derailed/k9s"
      "dteoh/sqa"
      "fabianishere/personal"
      "getantibody/tap"
      "gofireflyio/aiac"
      "golangci/tap"
      "hashicorp/tap"
      "heroku/brew"
      "homebrew/bundle"
      "homebrew/command-not-found"
      "homebrew/services"
      "joedrago/repo"
      "louisbrunner/valgrind"
      "teamookla/speedtest"
      "xgadget-lab/nexttrace"
      "zurawiki/brews"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "AmorphousDiskMark" = 1168254295;
      "DaisyDisk" = 411643860;
      "DevCleaner" = 1388020431;
      "Goodnotes" = 1444383602;
      "Infuse" = 1136220934;
      "Keynote" = 409183694;
      "LINE" = 539883307;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "NflxMultiSubs" = 1594059167;
      "Numbers" = 409203825;
      "Pages" = 409201541;
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
