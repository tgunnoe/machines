{ pkgs, flake, ... }:
{
  imports = [
    "${flake.inputs.hardware}/raspberry-pi/4"
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
        "8250.nr_uarts=1"
        "console=ttyAMA0,115200"
        "console=tty1"
        # Some gui programs need this
        "cma=128M"
    ];
    loader.raspberryPi.firmwareConfig = ''
      dtparam=audio=on
    '';
  };
  networking = {
    hostName = "sietch-tabr";
    firewall.allowedTCPPorts = [ 8000 30000 ];
    firewall.allowedUDPPorts = [ 30000 ];
    useDHCP = false;
    # wireless = {
    #   enable = true;
    #   #interfaces.wlan0.useDHCP = true;
    # };
    networkmanager.enable = true;
  };
  nixpkgs.overlays = [
    (self: super: {
      libcec = super.libcec.override { inherit (self) libraspberrypi; };
      fcitx-engines = pkgs.fcitx5;
    })
  ];

  # install libcec, which includes cec-client (requires root or "video" group, see udev rule below)
  # scan for devices: `echo 'scan' | cec-client -s -d 1`
  # set pi as active source: `echo 'as' | cec-client -s -d 1`

  services.udev.extraRules = ''
    # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
    SUBSYSTEM=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
  '';

  # optional: attach a persisted cec-client to `/run/cec.fifo`, to avoid the CEC ~1s startup delay per command
  # scan for devices: `echo 'scan' &gt; /run/cec.fifo ; journalctl -u cec-client.service`
  # set pi as active source: `echo 'as' &gt; /run/cec.fifo`
  # systemd.sockets."cec-client" = {
  #   after = [ "dev-vchiq.device" ];
  #   bindsTo = [ "dev-vchiq.device" ];
  #   wantedBy = [ "sockets.target" ];
  #   socketConfig = {
  #     ListenFIFO = "/run/cec.fifo";
  #     SocketGroup = "video";
  #     SocketMode = "0660";
  #   };
  # };
  # systemd.services."cec-client" = {
  #   after = [ "dev-vchiq.device" ];
  #   bindsTo = [ "dev-vchiq.device" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = ''${pkgs.libcec}/bin/cec-client -d 1'';
  #     ExecStop = ''/bin/sh -c "echo q &gt; /run/cec.fifo"'';
  #     StandardInput = "socket";
  #     StandardOutput = "journal";
  #     Restart="no";
  #   };
  # };
  environment.systemPackages = [
    #pkgs.openmw
    pkgs.libcec
  ];
  console = {
    keyMap = "dvorak";
    earlySetup = true;
  };
  sound.enable = true;
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.enableRedistributableFirmware = true;

  hardware.pulseaudio.enable = true;
  # home-manager.users.tgunnoe.wayland.windowManager.sway.config = {
  #   gaps = {
  #     inner = 20;
  #     outer = 25;
  #   };
  #   output = {
  #     "*" = {
  #       #bg = "${self}/artwork/background.jpg fill";
  #     };
  #     "Unknown 34CHR 0x00000000" = {
  #       resolution = "3440x1440@144hz";
  #     };
  #     "Ancor Communications Inc ASUS MG28U 0x00001BF4" = {
  #       resolution = "3840x2160@60hz";
  #       scale = "1.5";
  #       position = "2880 0";
  #     };
  #   };
  #   input = {
  #     "1:1:AT_Translated_Set_2_keyboard" = {
  #       xkb_layout = "dvorak,us";
  #       xkb_options = "ctrl:nocaps";
  #     };
  #   };
  # };
  i18n.defaultLocale = "en_US.UTF-8";
  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
  powerManagement.cpuFreqGovernor = "ondemand";
  system.stateVersion = "21.11";
}
