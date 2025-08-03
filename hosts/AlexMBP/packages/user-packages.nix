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
    glow # markdown in the terminal (https://github.com/charmbracelet/glow)
    
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
    
    # Utilities
    lnav # log file navigator (https://github.com/tstack/lnav)
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
    ctop # top for containers
    
    # Infrastructure as code
    terraform
    # terraformer
    # vagrant
    
    # DNS & networking
    # dnscontrol
    
    # Backup & storage
    restic
    
    # SSH
    ssh-copy-id
    
    # ============================================================================
    # NETWORKING & SECURITY
    # ============================================================================
    
    curlie
    curl
    xh
    mosh
    autossh
    magic-wormhole # p2p file transfer
    croc # p2p file transfer
    putty

    # TLS
    mkcert

    # Encryption
    age

    # Network analysis
    knot-dns
    tldx # domain availability search
    bandwhich
    doggo # modern dig
    hey
    iperf
    ipcalc # network address calculations for IPv4 and IPv6 (https://gitlab.com/ipcalc/ipcalc)
    mitmproxy
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
    pgcli
    
    # ============================================================================
    # SYSTEM UTILITIES
    # ============================================================================
    
    moreutils # https://joeyh.name/code/moreutils/

    # File operations
    entr # run arbitrary commands when files change
    bat
    hexyl # modern hex viewer
    coreutils-prefixed
    eza
    progress
    pv # progress bar for a pipe
    rsync
    television
    tree
    yazi
    dust # du in rust (https://github.com/bootandy/dust)
    create-dmg
    difftastic
    qpdf
    vbindiff # Visual Binary Diff compares files in hex & ASCII formats
    helix
       
    vivid # LS_COLORS generator (https://github.com/sharkdp/vivid)
    zoxide
    
    # Searcher
    fd
    fzf
    ripgrep
    silver-searcher
    pdfgrep

    # Data Science
    xan # csv file processing (https://github.com/medialab/xan)
    qsv # csv manipulation (https://github.com/dathere/qsv)
    visidata # Interactive terminal multitool for tabular data
    miller # awk, sed, cut, join, and sort for CSV, TSV, JSON
    gron # greppable JSON (https://github.com/tomnomnom/gron)

    # Text operations
    jq
    fx # terminal JSON viewer
    choose # modern cut+awk (https://github.com/theryangeary/choose)
    gnugrep
    sd
    jc # convert output of common cli tools to JSON (https://github.com/kellyjonbrazil/jc?tab=readme-ov-file#parsers)
    jo # generate JSON by simple commands
    yq-go # jq for YAML, JSON, XML, CSV, TOML and properties     
    htmlq # jq for HTML (https://github.com/mgdm/htmlq)

    # System monitoring
    duf
    jc
    osx-cpu-temp
    bottom # btm (https://github.com/ClementTsang/bottom)
    glances
    
    # ============================================================================
    # UTILITIES & TOOLS
    # ============================================================================
    
    # Recording & presentation
    asciinema
    slides
    
    # Documentation & help
    cht-sh
    tldr
    
    # Fun & misc
    cowsay
    lolcat
    neofetch
    
    # Notifications
    noti
    terminal-notifier
    
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
    # dex2jar
    hyperfine # cli command benchmarking

    # GitHub CLI Tools
    # @see https://github.com/cli/cli/blob/trunk/docs/gh-vs-hub.md#should-i-use-gh-or-hub
    gh
    hub

    # Nix Tools
    cachix

    # macOS-only packages
  ] ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [

    m-cli
    blueutil
    mas
    
    # Linux-only packages
  ]) ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [

    plocate # very fast `locate`
    
  ]);
}
