{ pkgs, ... }: {
  imports = [
    ./hyprland

    # Isolated features
    ./hidpi.nix
    ./swap-caps-ctrl.nix
    ./terminal.nix
    #./screencapture.nix
    ./fonts.nix
    ./touchpad-trackpoint.nix
    #./autolock.nix
    ./gnome-keyring.nix
    ./guiapps.nix
    #./polybar.nix
    ./hotplug.nix
  ];

  environment.systemPackages = with pkgs; [
    acpi
    imv
    #xorg.xmessage
  ];

  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = "${pkgs.greetd.wlgreet}/bin/wlgreet";
        user = "tgunnoe";
      };
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      wlr.enable = true;
      # gtk portal needed to make gtk apps happy
      gtkUsePortal = true;
    };
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.pulseaudio.enable = false;

  # Speed up boot
  # https://discourse.nixos.org/t/boot-faster-by-disabling-udev-settle-and-nm-wait-online/6339
  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

}
