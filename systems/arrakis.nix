{ flake, lib, pkgs, modulesPath, config, ... }:

rec {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.disko.nixosModules.disko
  ];

  fileSystems."/" =
    {
      device = "rpool/encrypted/local/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/5163-575B";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    {
      device = "rpool/encrypted/local/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/encrypted/safe/home";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    {
      device = "rpool/encrypted/safe/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

  swapDevices = [
    { device = "/dev/zvol/rpool/encrypted/swap"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" "g_ether" "i2c-dev" "i2c-i801" ];

    # source: https://grahamc.com/blog/nixos-on-zfs
    kernelParams = [
      "elevator=none"
      "mem_sleep_default=deep"
      "nvme.noacpi=1"
      "zfs.zfs_arc_max=8589934595"
      "zfs.zfs_arc_meta_limit_percent=50"
    ];

    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options snd-hda-intel model=dell-headset-multi
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        #efiSysMountPoint = "/boot/efi";
      };
    };
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "dm-snapshot" ];

      # source: https://grahamc.com/blog/erase-your-darlings
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r rpool/encrypted/local/root@blank
      '';
      secrets = { };
    };
    #zfs.package = pkgs.zfs_unstable;
  };
  console = {
    keyMap = lib.mkForce "dvorak";
    earlySetup = true;
  };
  home-manager.users.${flake.config.people.myself}.wayland.windowManager.sway.config = {
    gaps = {
      inner = 20;
      outer = 5;
    };
    output = {
      "*" = {
        bg = "${flake.self}/artwork/background.jpg fill";
      };
      eDP-1 = {
        resolution = "2256x1504@60hz";
        scale = "1.5";
        position = "3440 2508";
      };
      # "Beihai Century Joint Innovation Technology Co.,Ltd 34CHR Unknown" = {
      "Beihai Century Joint Innovation Technology Co.,Ltd 34CHR Unknown" = {
        #bg = "${self}/artwork/background.jpg fill";
        resolution = "3440x1440@144hz";
        position = "1192 1068";
        scale = "1";
      };
      "Ancor Communications Inc ASUS MG28U 0x00011AF4" = {
        #bg = "${self}/artwork/background.jpg fill";
        resolution = "2560x1440@60hz";
        scale = "1";
        position = "4944 1850";
      };
      "Optoma Corporation OPTOMA 1080P A7EH9220010" = {
        resolution = "1920x1080@60hz";
        position = "3024 1428";
      };
      "MON Monitor 8R33926O00QS" = {
        resolution = "1920x1080@60hz";
        position = "7504 2102";
        transform = "270";
      };


    };
    input = {
      "1:1:AT_Translated_Set_2_keyboard" = {
        xkb_layout = "us";
        xkb_variant = "dvorak";
        xkb_options = "ctrl:nocaps,grp:rctrl_toggle";
      };
      "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
        tap = "enabled";
        middle_emulation = "enabled";
        natural_scroll = "disabled";
        dwt = "enabled";

      };
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };
  #age.secrets.wifi.file = ../secrets/wifi/galaxian5g.age;
  services.logind.extraConfig = "HandlePowerKey=ignore";
  services.thermald.enable = true;
  services.hdapsd.enable = true;
  services.fstrim.enable = true;
  services.fprintd.enable = true;
  networking = {
    hostId = "4e80aabf";
    hostName = "arrakis";
    firewall.allowedTCPPorts = [ 8000 30000 ];
    firewall.allowedUDPPorts = [ 30000 ];
    #useDHCP = false;
    #    interfaces.wlp170s0.useDHCP = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    nameservers =
      [ "1.1.1.1" "1.0.0.1" ];
    wireless = {
      iwd.enable = true;
      networks = {
      };
      #environmentFile = age.secrets..file = ../secrets/gh-runner/partner-chains/token-1.age;
      #environmentFile = age.secrets.wifi.file.path;
    };
  };
  services.openssh = {
    enable = true;
    hostKeys =
      [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persist/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    openFirewall = true;
  };
  #age.secretsDir = "/persist/agenix";
  #age.secretsMountPoint = "/persist/agenix.d";
  time.timeZone = "America/New_York";
  services.ntp.enable = true;
  services.hardware.openrgb.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;



  # TODO: Generalize laptop profile

  environment.systemPackages = with pkgs; [
    acpi
    libinput
    lm_sensors
    wirelesstools
    libcamera
    webcamoid
    v4l-utils
    pciutils
    usbutils
    fwupd
  ];
  #networking.wireless.iwd.enable = true;
  #networking.wireless.enable = true;
  hardware.bluetooth.enable = true;

  # to enable brightness keys 'keys' value may need updating per device
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 225 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -A 5";
      }
      {
        keys = [ 224 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -U 5";
      }
    ];
  };

  #services.chrony.enable = true;
  services.timesyncd.enable = false;

  #sound.mediaKeys = lib.mkIf (!config.hardware.pulseaudio.enable) {
  #  enable = true;
  #  volumeStep = "1dB";
  #};

  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_HWP_ON_AC = "performance";
  };

  services.logind.lidSwitch = "suspend";

  services.fwupd.enable = true;


  system.stateVersion = "22.11";

}
