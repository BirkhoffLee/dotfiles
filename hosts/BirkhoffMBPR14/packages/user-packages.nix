{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
    azure-cli
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
    terraformer
    vagrant
    skaffold
    ssh-copy-id
    yamllint
    wakeonlan
    gotop

    # dev
    caddy
    redis
    httpie
    go
    golangci-lint
    rustup
    R
    rbenv
    yarn
    micromamba

    # app
    discord
    raycast
    rectangle
    vscode
    yubico-piv-tool
    utm
    postman
    iterm2
    iina

    # util
    m-cli
    cht-sh
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
    # magic-wormhole
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
    youtube-dl

    osx-cpu-temp
    dockutil
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
    exa
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
    mitmproxy
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
    speedtest-cli
    wireguard-go
    wireguard-tools

    # authentication
    pam-reattach
    pinentry
    pinentry_mac
    gnupg
    reattach-to-user-namespace
  ];
}
