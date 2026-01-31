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

  # Wayland desktop - Labwc (lightweight Openbox-like compositor)
  programs.labwc.enable = true;

  # greetd with tuigreet for Wayland - override the shared Hyprland default
  services.greetd.settings.default_session.command = lib.mkForce "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd labwc";

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Allow passwordless sudo for wheel group (needed for colmena deployments)
  security.sudo.wheelNeedsPassword = false;

  # Extra packages specific to this Pi
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    # Labwc desktop environment
    labwc
    foot           # Lightweight Wayland terminal
    wofi           # App launcher
    nwg-panel      # Taskbar with start menu
    nwg-drawer     # Full-screen app launcher (optional)
    nwg-look       # GTK theme switcher
    grim
    slurp
    wl-clipboard
    mako           # Notifications
    pcmanfm        # File manager
    swaybg         # Wallpaper
  ];

  system.stateVersion = "24.11";
}
