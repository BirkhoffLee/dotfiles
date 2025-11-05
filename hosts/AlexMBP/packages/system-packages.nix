{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ack
    bashInteractive
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
