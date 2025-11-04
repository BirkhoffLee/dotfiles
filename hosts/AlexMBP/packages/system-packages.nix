{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ack
    bashInteractive
    ghostty.terminfo
    cmake
    dialog
    foremost
    openssh
    screen
    ruby
    zsh
    wget
    mtr
    ncdu
  ];
}
