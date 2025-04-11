{ pkgs, flake, modulesPath, lib, ... }:
{
  ### root password is empty by default ###
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.disko.nixosModules.disko
  ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/91d1dfd6-bf33-46ad-8fc7-3ff39ba826ff";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/2EB0-BB29";
      fsType = "vfat";
    };
  # fileSystems."/data" =
  #   {
  #     device = "/dev/disk/by-uuid/154d7e98-af18-495d-9f00-94f8cbff9271";
  #     fsType = "ext4";
  #     options = [ "remount" "rw" "uid=1000" "gid=users" ];
  #   };
  fileSystems."/tmp" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "nosuid" "nodev" "relatime" "size=32G" ];
    };

  #age.secrets.salusa.file = "${self}/secrets/salusa.age";
  nixpkgs.hostPlatform = "x86_64-linux";
  swapDevices =
    [{ device = "/dev/disk/by-uuid/04983f36-41ad-4dea-9227-6a3f06fbbb11"; }];

  # high-resolution display
  #hardware.video.hidpi.enable = lib.mkDefault true;
  hardware.bluetooth.enable = true;

  boot = {
    #binfmt.emulatedSystems = [ "aarch64-linux" ];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    kernelPatches = [ ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        useOSProber = true;
        extraEntries = ''
            menuentry "Windows" {
              insmod part_gpt
              insmod fat
              insmod search_fs_uuid
              insmod chain
              search --fs-uuid --set=root 0A783C09783BF255
              chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      secrets = {
        "keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
      };
      luks.devices = {
        root = {
          name = "root";
          device = "/dev/disk/by-uuid/6e57d03c-999a-47e1-a38c-aca0e55b4013"; # UUID for /dev/nvme01np2
          preLVM = true;
          keyFile = "/keyfile0.bin";
          allowDiscards = true;
        };
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
  networking.nameservers =
    [ "1.1.1.1" "1.0.0.1" ];

  networking = {
    hostId = "e53dd769";
    hostName = "chapterhouse";
    firewall.allowedTCPPorts = [ 8000 ];
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
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.enable = true;

  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "20.03";

}
