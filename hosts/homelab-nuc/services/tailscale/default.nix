{ config, pkgs, ... }:
{
  age.secrets.tailscale-authkey.file = ../../../../secrets/armored-tailscale-authkey.age;

  services.tailscale = {
    enable = true;
    package = pkgs.pkgs-unstable.tailscale;
    openFirewall = true;
    authKeyFile = config.age.secrets."tailscale-authkey".path;
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-routes=192.168.0.0/24"
    ];
  };

  # These had to be run on the machine manually:
  # $ tailscale up --advertise-routes=192.168.0.0/24 --advertise-exit-node
  # $ tailscale serve --service=svc:atuin --https=443 127.0.0.1:8010
}
