{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python311
    python311Packages.pip
    # python311Packages.virtualenv
    python311Packages.ansible-core

    zsh-completions
    zsh-fast-syntax-highlighting
    zsh-powerlevel10k

    # git
    git
    # git-delta
    git-lfs
    git-extras
    git-open
    # git-recent
    gptcommit

    # ops
    awscli2
    # azure-cli # https://github.com/NixOS/nixpkgs/issues/348995
    oci-cli
    backblaze-b2
    aws-vault
    dnscontrol
    aiac
    k9s
    kubectx
    kustomize
    nomad
    packer
    restic
    terraform
    testssl
    terraformer
    # vagrant # https://github.com/grpc/grpc/pull/34481
    skaffold
    ssh-copy-id
    yamllint
    wakeonlan
    gotop
    duf

    # dev
    nodejs_20
    caddy
    redis
    httpie
    uv
    go
    golangci-lint
    rustup
    R
    rbenv
    yarn
    micromamba
    
    # ai
    gfortran
    # openblas
    openblas.dev

    # app
    spotify
    discord
    rectangle
    yubico-piv-tool
    utm
    iterm2
    iina

    # util
    mactop
    m-cli
    cht-sh
    stripe-cli
    asciinema
    bfg-repo-cleaner
    diff-so-fancy
    difftastic
    cowsay
    gnugrep
    chezmoi
    gh
    htop
    hub
    jc
    lolcat
    lux
    yt-dlp
    magic-wormhole
    neofetch
    noti
    ouch
    powershell
    procs
    putty
    qpdf
    rename
    slides
    tmux
    tree
    vbindiff
    viddy
    yt-dlp

    osx-cpu-temp
    wifi-password
    mas

    imagemagick
    ffmpeg
    optipng

    pv
    jq
    lsd
    entr
    bat
    eza
    fasd
    fd
    progress
    coreutils-prefixed
    fd
    fzf
    silver-searcher
    terminal-notifier
    zoxide

    # build
    autoconf
    # gcc
    automake
    wasm-pack
    autossh
    pkg-config

    # network
    bandwhich
    mitmproxy
    trippy
    knot-dns
    hey
    nexttrace
    nmap
    curl
    iperf
    mosh
    nali
    rtmpdump
    socat
    sqlmap
    sslscan
    stress
    tcpflow
    tcping-go
    tcpreplay
    tcptraceroute
    testssl
    speedtest-cli
    wireguard-go
    wireguard-tools

    # authentication
    pam-reattach
    pinentry_mac
    gnupg
    reattach-to-user-namespace
  ];
}
