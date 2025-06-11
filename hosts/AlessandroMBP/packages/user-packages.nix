{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # python
    uv
    # TODO: replace entirely with uv?
    # python311
    # python311Packages.ansible-core
    # python311Packages.pip
    # python311Packages.virtualenv

    # shell
    zsh-completions
    zsh-fast-syntax-highlighting
    zsh-powerlevel10k
    
    atuin

    # git
    git
    git-lfs
    git-extras
    git-open
    # git-recent
    gptcommit

    # infra
    # awscli2
    # azure-cli
    # oci-cli
    backblaze-b2
    # aws-vault
    # dnscontrol
    # k9s
    # kubectx
    # kustomize
    # nomad
    # packer
    restic
    terraform
    # terraformer
    # vagrant # FIXME: https://github.com/grpc/grpc/pull/34481
    # skaffold
    ssh-copy-id

    # dev
    caddy
    go
    golangci-lint
    httpie
    micromamba
    nodejs_22
    R
    rbenv
    redis
    rustup
    yamllint
    yarn
    
    # ai
    gfortran
    openblas.dev

    # util
    asciinema
    autossh
    bfg-repo-cleaner
    cht-sh
    cowsay
    diff-so-fancy
    difftastic
    duf
    gh
    gnugrep
    gotop
    htop
    hub
    jc
    lolcat
    lux
    m-cli
    mactop
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
    stripe-cli
    television
    tmux
    vbindiff
    viddy
    yt-dlp
  
    # some macos stuff
    osx-cpu-temp

    # media
    ffmpeg
    imagemagickBig
    optipng

    # core utlities
    bat
    coreutils-prefixed
    entr
    eza
    fasd
    fd
    fzf
    jq
    lsd
    progress
    pv
    rsync
    silver-searcher
    terminal-notifier
    tree
    zoxide

    # build
    autoconf
    automake
    # gcc
    pkg-config
    wasm-pack

    # network
    bandwhich
    curl
    hey
    iperf
    knot-dns
    mitmproxy
    mosh
    nali
    nexttrace
    nmap
    rtmpdump
    socat
    sqlmap
    sslscan
    stress
    tcpflow
    tcping-go
    tcpreplay
    tcptraceroute
    trippy
    wakeonlan
    wireguard-go
    wireguard-tools

    # authentication
    gnupg
    pam-reattach
    pinentry_mac
    reattach-to-user-namespace
    yubico-piv-tool
  ];
}
