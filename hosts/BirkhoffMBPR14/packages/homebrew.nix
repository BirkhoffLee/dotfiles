{
  # Homebrew has to be installed first.
  # This installs system-wide packages and Mac App Store apps.
  homebrew = {
    enable = true;

    brews = [
      "blueutil"
      "carthage"
      "create-dmg"
      "dex2jar"
      "dns2tcp"
      "dnslookup"
      "flarectl"
      "git-delta"
      "gnu-getopt"
      "gnu-sed"
      "gnu-tar"
      "hashpump"
      "helm"
      "heroku-node"
      "hopenpgp-tools"
      "hydra"
      "knock"
      "kubernetes-cli"
      "locateme"
      "macvim"
      "screenresolution"
      "tcptrace"
      "telnet"
      "testssl"
      "tidy-html5"
      "whatmask"
      "ykman"
      "ykpers"
      "ytop"
    ];

    casks = [
      "1password"
      "1password-cli"
      "adobe-creative-cloud"
      "adoptopenjdk"
      "arc"
      "balenaetcher"
      "cloudytabs"
      "dropbox"
      "font-fira-code"
      "font-hack-nerd-font"
      "font-menlo-for-powerline"
      "font-source-code-pro"
      "google-chrome"
      "handbrake"
      "imazing"
      "key-codes"
      "linkliar"
      "macmediakeyforwarder"
      "mounty"
      "netnewswire"
      "nrlquaker-winbox"
      "orbstack"
      "parsec"
      "quicklook-csv"
      "quicklook-json"
      "quicklookapk"
      "setapp"
      "skype"
      "sloth"
      "sublime-text"
      "suspicious-package"
      "teamviewer"
      "telegram"
      "typora"
      "wechat"
      "wireshark"
      "zoom"
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
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/command-not-found"
      "homebrew/core"
      "homebrew/services"
      "joedrago/repo"
      "louisbrunner/valgrind"
      "teamookla/speedtest"
      "xgadget-lab/nexttrace"
      "zurawiki/brews"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Craft" = 1487937127;
      "DaisyDisk" = 411643860;
      "DevCleaner" = 1388020431;
      "GarageBand" = 682658836;
      "Goodnotes" = 1444383602;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "LINE" = 539883307;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "QQ" = 451108668;
      "Slack" = 803453959;
      "Tab Space" = 1473726602;
      "Tailscale" = 1475387142;
      "TestFlight" = 899247664;
      "The Unarchiver" = 425424353;
      "WhatsApp" = 1147396723;
      "WireGuard" = 1451685025;
      "Xcode" = 497799835;
      "Yoink" = 457622435;
    };
  };
}
