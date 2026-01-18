# Raspberry Pi 5 configuration
{ pkgs, lib, flake, ... }:
{
  time.timeZone = "America/New_York";

  # Root initial password for setup (user is created via nixosModules.my-home)
  users.users.root.initialPassword = "root";

  networking = {
    hostName = "jacurutu";
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall.allowedTCPPorts = [ 30000 ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];

  # Allow unsigned paths from trusted users (needed for colmena deployments)
  nix.settings.trusted-users = [ "root" "tgunnoe" ];

  # Raspberry Pi 5 specific settings
  raspberry-pi-nix = {
    board = "bcm2712";
    libcamera-overlay.enable = false;
  };

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
    raspberry-pi = {
      config = {
        pi5 = {
          options = {
            arm_boost = {
              enable = true;
              value = true;
            };
          };
          dt-overlays = {
            vc4-kms-v3d = {
              enable = true;
              params = { cma-512 = { enable = true; }; };
            };
          };
        };
        all = {
          base-dt-params = {
            BOOT_UART = {
              value = 1;
              enable = true;
            };
            uart_2ndstage = {
              value = 1;
              enable = true;
            };
            krnbt = {
              enable = true;
              value = "on";
            };
            spi = {
              enable = true;
              value = "on";
            };
          };
          options = {
            arm_64bit = {
              enable = true;
              value = true;
            };
            camera_auto_detect = {
              enable = true;
              value = true;
            };
            display_auto_detect = {
              enable = true;
              value = true;
            };
            disable_overscan = {
              enable = true;
              value = true;
            };
          };
        };
      };
    };
  };

  security.rtkit.enable = true;

  # Desktop environment - XFCE with Windows XP theme (WinTC depends on XFCE components)
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Register WinTC session with the display manager
  services.displayManager.sessionPackages = [
    flake.inputs.xfce-winxp-tc.packages.aarch64-linux.default
  ];

  # Auto-login to WinTC session
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "tgunnoe";
  services.displayManager.defaultSession = "wintc";

  # Allow passwordless sudo for wheel group (needed for colmena deployments)
  security.sudo.wheelNeedsPassword = false;

  # Extra packages specific to this Pi
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    gjs
    flake.inputs.xfce-winxp-tc.packages.aarch64-linux.default
  ];

  # Home Manager configuration for xfce-winxp-tc
  home-manager.users.${flake.people.myself} = {
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

  system.stateVersion = "24.11";
}
