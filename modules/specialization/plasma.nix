# KDE Plasma (Wayland)
{ lib, pkgs, ... }: {
  specialisation.plasma.configuration = {
    # Disable the default GDM/GNOME and use SDDM for Plasma
    services.displayManager.gdm.enable = lib.mkForce false;
    services.desktopManager.gnome.enable = lib.mkForce false;

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
