{ pkgs, lib, ... }: {
  time.timeZone = "America/New_York";
  users.users.root.initialPassword = "root";
  networking = {
    hostName = "jacurutu";
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
  };
  raspberry-pi-nix.board = "bcm2711";
  hardware = {
    raspberry-pi = {
      config = {
        pi4 = {
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
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
