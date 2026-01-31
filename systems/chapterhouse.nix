{ pkgs, flake, modulesPath, lib, ... }:
{
  ### root password is empty by default ###
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.disko.nixosModules.disko
    flake.inputs.ragenix.nixosModules.age
    flake.inputs.sops-nix.nixosModules.sops
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b03dc47d-31b3-4426-8dec-d888d38923b7";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-4decceca-df36-4227-9e81-4bb97e7a777d".device = "/dev/disk/by-uuid/4decceca-df36-4227-9e81-4bb97e7a777d";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/48F2-1E37";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ae389b46-5831-444b-9dfc-29ee1bf7cb71"; }
    ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  #age.secrets.salusa.file = "${self}/secrets/salusa.age";
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
        enableCryptodisk = true;
        useOSProber = true;
      };
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
	"luks-5b9efbe1-6f6a-4587-abb2-3883e109bbfc".device = "/dev/disk/by-uuid/5b9efbe1-6f6a-4587-abb2-3883e109bbfc";
      };
    };
    supportedFilesystems = [ "ntfs" ];
    #zfs.enabled = lib.mkForce true;
  };
  # home-manager.users.tgunnoe.wayland.windowManager.sway.config = {
  #   gaps = {
  #     inner = 20;
  #     outer = 5;
  #   };
  #   output = {
  #     "Monoprice.Inc 43305 0000000000000" = {
  #       #bg = "${self}/artwork/background.jpg fill";
  #       resolution = "5120x1440@120hz";
  #       position = "0 0";
  #       scale = "1";
  #     };
  #     "Beihai Century Joint Innovation Technology Co.,Ltd 34CHR Unknown" = {
  #       #bg = "${self}/artwork/background.jpg fill";
  #       resolution = "3440x1440@144hz";
  #       position = "2560 1440";
  #       scale = "1";
  #     };

  #     "Ancor Communications Inc ASUS MG28U 0x00001BF4" = {
  #       #bg = "${self}/artwork/background.jpg fill";
  #       resolution = "3840x2160@60hz";
  #       position = "0 1440";
  #       scale = "1.5";
  #       #transform = "270";
  #     };
  #   };

  # };
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
    hostId = "b5a0db89";
    hostName = "chapterhouse";
    firewall.allowedTCPPorts = [ 8000 5029 ];
    firewall.allowedUDPPorts = [ 8000 5029 ];
    enableIPv6 = false;
    useDHCP = false;
    interfaces = {
      # enp11s0 = {
      #   useDHCP = false;
      #   ipv4 = {
      #     addresses = [
      #       {
      #         address = "192.168.1.5";
      #         prefixLength = 25;
      #       }
      #     ];
      #   };
      # };
    };
  };
  services.openssh.openFirewall = true;
  services.openssh.enable = true;
  location = {
    latitude = 38.0;
    longitude = -80.0;
  };
  
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  # services.gnome.gnome-browser-connector.enable = true;
  # services.gnome.sushi.enable = true;
  # services.gnome.core-shell.enable = true;
  # services.gnome.core-utilities.enable = true;

  # Hyprland is enabled via nixos/gui/hyprland module
  # greetd/tuigreet is enabled via nixos/gui/default.nix

  # Enable Hyprland for this machine's home-manager
  home-manager.users.tgunnoe.wayland.windowManager.hyprland.enable = true;

  environment.systemPackages = [
    pkgs.gjs
  ];
  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = false;
  
  # Configure chapterhouse as Nebula lighthouse
  # services.nebula.networks.home = {
  #   isLighthouse = lib.mkForce true;
  #   # Lighthouse doesn't need to use relays (it is the relay)
  #   relays = lib.mkForce [];
  # };
  
  system.stateVersion = "24.11";

}
