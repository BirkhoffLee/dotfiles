# i3 (X11)
{ lib, pkgs, ... }: {
  specialisation.i3.configuration = {
    # We need an XDG portal for various applications to work properly,
    # such as Flatpak applications.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    # Disable the default GDM display manager and use LightDM for i3
    services.displayManager.gdm.enable = lib.mkForce false;
    services.desktopManager.gnome.enable = lib.mkForce false;

    services.displayManager.defaultSession = "none+i3";

    services.xserver = {
      enable = true;
      xkb.layout = "us";
      dpi = 220;

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "fill";
      };

      displayManager = {
        lightdm.enable = true;

        # AARCH64: For now, on Apple Silicon, we must manually set the
        # display resolution. This is a known issue with VMware Fusion.
        sessionCommands = ''
          ${pkgs.xorg.xset}/bin/xset r rate 200 40
        '';
      };

      windowManager = {
        i3.enable = true;
      };
    };
  };
}
