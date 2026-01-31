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

  # Labwc Wayland compositor
  programs.labwc.enable = true;

  # greetd with gtkgreet (graphical Wayland greeter)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Use cage to run gtkgreet in a minimal Wayland session
        command = lib.mkForce "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
        user = "greeter";
      };
    };
  };

  # gtkgreet config - list available sessions
  environment.etc."greetd/environments".text = ''
    labwc
  '';

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Allow passwordless sudo for wheel group (needed for colmena deployments)
  security.sudo.wheelNeedsPassword = false;

  # Labwc autostart configuration for all users
  environment.etc."xdg/labwc/autostart".text = ''
    # Set dark background
    swaybg -c '#21252b' &

    # Set dark GTK theme
    export GTK_THEME=Adwaita:dark
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    # Start sfwbar panel (taskbar with start menu - used in official labwc screenshots)
    sfwbar &

    # Notifications
    mako &
  '';

  # Labwc menu configuration (right-click menu)
  environment.etc."xdg/labwc/menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_menu>
      <menu id="root-menu" label="">
        <item label="Terminal"><action name="Execute"><command>foot</command></action></item>
        <item label="File Manager"><action name="Execute"><command>pcmanfm</command></action></item>
        <separator />
        <item label="Reconfigure"><action name="Reconfigure" /></item>
        <item label="Exit"><action name="Exit" /></item>
      </menu>
    </openbox_menu>
  '';

  # Extra packages specific to this Pi
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    # Labwc desktop environment
    labwc
    labwc-tweaks   # Config/theme utility (shown in official screenshots)
    foot           # Lightweight Wayland terminal
    wofi           # App launcher
    sfwbar         # Taskbar panel (used in official labwc screenshots)
    grim
    slurp
    wl-clipboard
    mako           # Notifications
    pcmanfm        # File manager
    swaybg         # Wallpaper
    cage           # For gtkgreet
    # Theming
    adwaita-icon-theme
    gnome-themes-extra  # Adwaita-dark theme
    dconf           # For gsettings
    glib            # gsettings command
  ];

  system.stateVersion = "24.11";
}
