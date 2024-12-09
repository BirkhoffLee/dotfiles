{
  # Homebrew has to be installed first.
  # This installs system-wide packages and Mac App Store apps.
  homebrew = {
    enable = true;

    brews = [
      "blueutil"
      "borgbackup/tap/borgbackup-fuse"
      "carthage"
      "create-dmg"
      "dex2jar"
      "dns2tcp"
      "ameshkov/tap/dnslookup"
      "flarectl"
      "git-delta"
      "gnu-getopt"
      "gnu-sed"
      "gnu-tar"
      "hashpump"
      "helm"
      "hopenpgp-tools"
      "hydra"
      "knock"
      "kubernetes-cli"
      "locateme"
      "macvim"
      "screenresolution"
      "tcptrace"
      "telnet"
      "tidy-html5"
      "whatmask"
      "ykman"
      "ykpers"
    ];

    casks = [
      "1password"
      "1password-cli"
      "adobe-creative-cloud"
      "adoptopenjdk"
      "arc"
      "balenaetcher"
      "dropbox"
      "font-fira-code"
      "font-hack-nerd-font"
      "font-menlo-for-powerline"
      "font-source-code-pro"
      "google-chrome"
      "handbrake"
      "imazing"
      "jordanbaird-ice"
      "key-codes"
      "macfuse"
      "mounty"
      "nrlquaker-winbox"
      "orbstack"
      "quicklook-csv"
      "quicklook-json"
      "quicklookapk"
      "raycast"
      "setapp"
      "skype"
      "sublime-text"
      "suspicious-package"
      "telegram"
      "transmit"
      "typora"
      "vorta"
      "wechat"
      "wireshark"
    ];

    taps = [
      "adoptopenjdk/openjdk"
      "ameshkov/tap"
      "birkhofflee/birkhoff"
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
      "zurawiki/brews"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "DaisyDisk" = 411643860;
      "DevCleaner" = 1388020431;
      "iMovie" = 408981434;
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
      "WhatsApp" = 1147396723;
      "WireGuard" = 1451685025;
      "Xcode" = 497799835;
      "Yoink" = 457622435;
    };
  };
}
