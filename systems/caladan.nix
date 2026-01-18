{ pkgs, flake, people, modulesPath, lib, config, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.disko.nixosModules.disko
    flake.inputs.ragenix.nixosModules.age
    flake.inputs.sops-nix.nixosModules.sops
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b5718ae2-4353-4405-a8b6-c8c256baf00d";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EC7C-82F4";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d7931054-5d5d-4694-b94f-7e2f4d526052"; }
    ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.bluetooth.enable = true;
  services.fwupd.enable = true;
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "k10temp" "kvm-amd" ];
    kernelPatches = [ ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        #efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        version = 2;
        efiSupport = true;
        #enableCryptodisk = true;
        useOSProber = true;
      };
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
    };
    supportedFilesystems = [ "ntfs" ];
  };
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    #    dns = lib.mkForce "none";
    # extraConfig = ''
    #   [main]
    #   systemd-resolved=false
    # '';
  };

  # networking.nameservers =
  #   [ "1.1.1.1" "1.0.0.1" ];

  networking = {
    hostId = "0fc1e2c1";
    hostName = "caladan";
    firewall.allowedTCPPorts = [ 8000 ];
    enableIPv6 = false;
    useDHCP = false;
    interfaces = {
    };
  };
  services.openssh.openFirewall = true;
  services.openssh.enable = true;
  location = {
    latitude = 38.0;
    longitude = -80.0;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.enableWaylandSession = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "tgunnoe";

  environment.systemPackages = [
    pkgs.gjs
    pkgs.kdePackages.krohnkite
    flake.inputs.xfce-winxp-tc.packages.x86_64-linux.default
  ];

  # Home Manager configuration for xfce-winxp-tc
  home-manager.users.${people.myself} = {
    imports = [
      flake.inputs.xfce-winxp-tc.homeManagerModules.default
    ];

    home.packages = with pkgs; [
      xcape  # For Super key mapping in xinitrc
      xfce.xfce4-power-manager
      xfce.xfce4-terminal
      xfce.xfce4-taskmanager
      xfce.mousepad
      xfce.ristretto
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
    ];

    # Configure the Windows XP theme
    win-tc = {
      theme = "Windows XP style";  # Blue theme
      cursor = "Windows XP Standard";
      icons = "luna";
      SKU = "xpclient-pro";
    };

    # X11 configuration files for WinTC session
    home.file = {
      "x.conf".text = ''
        Section "Files"
          ModulePath "${pkgs.xorg.xf86inputlibinput}/lib/xorg/modules"
          ModulePath "${pkgs.xorg.xorgserver}/lib/xorg/modules"
        EndSection

        Section "InputClass"
          Identifier "libinput all devices"
          MatchDevicePath "/dev/input/event*"
          Driver "libinput"
        EndSection
      '';
      "session.start".text = ''startx -- -config x.conf vt$XDG_VTNR'';
      ".xinitrc".text = ''
        export DESKTOP_SESSION="WINTC"
        export XDG_CURRENT_DESKTOP="WINTC"
        export WINDEBUG="1"

        xfsettingsd --disable-wm-check --replace --daemon
        xcape -e 'Super_L=Alt_L|F1'

        dbus-run-session -- smss
        exit
      '';
    };
  };

  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = false;
  
  system.stateVersion = "24.11";

}
