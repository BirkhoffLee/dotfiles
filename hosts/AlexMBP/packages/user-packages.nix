{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ============================================================================
    # DEVELOPMENT TOOLS
    # ============================================================================
    
    # Python
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

    # Build tools
    autoconf
    automake
    # gcc
    pkg-config
    wasm-pack
    
    # Package managers
    uv

    # Language Servers (and/or its toolchains)
    bash-language-server
    cmake-language-server
    vscode-css-languageserver # css, scss
    beam28Packages.elixir-ls
    gopls # go
    graphql-language-service-cli # graphql
    helm-ls # helm
    haskell-language-server # haskell
    docker-language-server # dockerfile, compose files, bake
    terraform-ls # hcl
    superhtml # html
    typescript-language-server # js, ts, tsx
    jq-lsp # jq
    vscode-json-languageserver # json
    kotlin-language-server
    texlab # latex
    lua-language-server # lua
    marksman # markdown
    nil # nix
    perlnavigator # perl
    intelephense # php
    ruff # python
    R
    rustup # rust
    solc # solidity
    svelte-language-server # svelte
    systemd-lsp # systemd
    taplo # TOML
    vue-language-server
    yaml-language-server
    zls # zig
    
    # ============================================================================
    # SHELL & TERMINAL
    # ============================================================================
    
    # Shell enhancements
    zsh-completions
    zsh-fast-syntax-highlighting
    zsh-powerlevel10k
    emojify
    atuin
    
    # Terminal utilities
    tmux
    htop
    gotop
    mactop
    procs
    viddy
    lesspipe
    
    # ============================================================================
    # VERSION CONTROL
    # ============================================================================
    
    # Git
    git
    git-lfs
    git-extras # https://github.com/tj/git-extras/blob/main/Commands.md
    # git-open # `git open` to open the GitHub page or website for a repo FIXME: doesn't work
    git-recent # `git recent` to browse latest local git branches interactively
    lazygit
        
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
    ookla-speedtest
    tcping-go
    tcpreplay
    tcptraceroute
    trippy
    wakeonlan
    dns2tcp
    tcptrace
    dnslookup
    
    # VPN & security
    wireguard-go
    wireguard-tools
    sqlmap
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
    aichat
    
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
    yazi
    
    # System monitoring
    duf
    jc
    osx-cpu-temp
    bottom # btm (https://github.com/ClementTsang/bottom)
    
    # ============================================================================
    # UTILITIES & TOOLS
    # ============================================================================
    
    # Recording & presentation
    asciinema
    slides
    
    # File manipulation
    create-dmg
    difftastic
    qpdf
    vbindiff # Visual Binary Diff compares files in hex & ASCII formats
    helix
    
    # Communication
    autossh
    magic-wormhole
    putty
    
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
    
    # Download & media
    lux
    yt-dlp
    
    # ============================================================================
    # MEDIA PROCESSING
    # ============================================================================
    
    ffmpeg
    exiftool
    imagemagickBig
    optipng
    pngpaste
    
    # ============================================================================
    # CLI TOOLS
    # ============================================================================
    
    powershell
    stripe-cli
    flarectl
    tldx
    # dex2jar

    # GitHub CLI Tools
    # @see https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md#should-i-use-gh-or-hub
    gh
    hub

    # Nix Tools
    cachix
  ];
}
