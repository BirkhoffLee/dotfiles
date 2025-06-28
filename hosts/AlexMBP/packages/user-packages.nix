{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ============================================================================
    # DEVELOPMENT TOOLS
    # ============================================================================
    
    # Python
    uv
    # TODO: replace entirely with uv?
    # python311
    # python311Packages.ansible-core
    # python311Packages.pip
    # python311Packages.virtualenv
    
    # Go
    go
    golangci-lint
    
    # Node.js
    nodejs_22
    yarn
    
    # Ruby
    rbenv
    
    # Rust
    rustup
    
    # R
    R
    
    # Build tools
    autoconf
    automake
    # gcc
    pkg-config
    wasm-pack
    
    # Package managers
    micromamba
    
    # ============================================================================
    # SHELL & TERMINAL
    # ============================================================================
    
    # Shell enhancements
    zsh-completions
    zsh-fast-syntax-highlighting
    zsh-powerlevel10k
    atuin
    
    # Terminal utilities
    tmux
    htop
    gotop
    mactop
    procs
    viddy
    
    # ============================================================================
    # VERSION CONTROL
    # ============================================================================
    
    # Git
    git
    git-lfs
    git-extras # https://github.com/tj/git-extras/blob/main/Commands.md
    git-open # `git open` to open the GitHub page or website for a repo
    git-recent # `git recent` to browse latest local git branches interactively
    gptcommit
    
    # Git tools
    bfg-repo-cleaner
    
    # ============================================================================
    # INFRASTRUCTURE & DEVOPS
    # ============================================================================
    
    # Cloud providers
    # awscli2
    # azure-cli
    # oci-cli
    backblaze-b2
    # aws-vault
    
    # Container & orchestration
    # k9s
    # kubectx
    # kustomize
    # nomad
    # packer
    # skaffold
    # helm
    
    # Infrastructure as code
    terraform
    # terraformer
    # vagrant
    
    # DNS & networking
    # dnscontrol
    knot-dns
    
    # Backup & storage
    restic
    
    # SSH
    ssh-copy-id
    
    # ============================================================================
    # NETWORKING & SECURITY
    # ============================================================================
    
    # Network analysis
    bandwhich
    curl
    hey
    iperf
    mitmproxy
    mosh
    nali
    nexttrace
    nmap
    rtmpdump
    socat
    sslscan
    stress
    tcpflow
    tcping-go
    tcpreplay
    tcptraceroute
    trippy
    wakeonlan
    dns2tcp
    tcptrace
    dnslookup
    
    # SSH
    putty
    
    # VPN & security
    wireguard-go
    wireguard-tools
    sqlmap
    hashpump
    testssl
    
    # ============================================================================
    # AUTHENTICATION & SECURITY
    # ============================================================================
    
    gnupg
    pam-reattach
    pinentry_mac
    reattach-to-user-namespace
    yubico-piv-tool
    
    # ============================================================================
    # AI & MACHINE LEARNING
    # ============================================================================
    
    gfortran
    openblas.dev
    gemini-cli
    ollama
    
    # ============================================================================
    # DEVELOPMENT UTILITIES
    # ============================================================================
    
    # Web development
    caddy
    httpie
    
    # Code quality
    yamllint
    
    # Databases
    redis
    
    # ============================================================================
    # SYSTEM UTILITIES
    # ============================================================================
    
    # File operations
    bat
    vivid
    coreutils-prefixed
    entr
    eza
    fasd
    fd
    fzf
    gnugrep
    jq
    # lsd
    progress
    pv
    rsync
    silver-searcher
    television
    tree
    zoxide
    
    # System monitoring
    duf
    jc
    osx-cpu-temp
    
    # ============================================================================
    # UTILITIES & TOOLS
    # ============================================================================
    
    # Recording & presentation
    asciinema
    slides
    
    # File manipulation
    create-dmg
    diff-so-fancy
    difftastic
    ouch
    qpdf
    rename
    vbindiff
    
    # Communication
    autossh
    magic-wormhole
    
    # Documentation & help
    cht-sh
    
    # Fun & misc
    cowsay
    lolcat
    neofetch
    
    # Notifications
    noti
    terminal-notifier
    
    # macOS specific
    m-cli
    blueutil
    mas
    macvim
    
    # Download & media
    lux
    yt-dlp
    
    # ============================================================================
    # MEDIA PROCESSING
    # ============================================================================
    
    ffmpeg
    imagemagickBig
    optipng
    
    # ============================================================================
    # CLI TOOLS
    # ============================================================================
    
    powershell
    stripe-cli
    flarectl
    # dex2jar

    # GitHub CLI Tools
    # @see https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md#should-i-use-gh-or-hub
    gh
    hub
  ];
}
