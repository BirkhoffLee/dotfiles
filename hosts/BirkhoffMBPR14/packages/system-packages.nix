{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ack
    bash
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
