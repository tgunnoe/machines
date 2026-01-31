{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    style = (builtins.readFile ./waybar.css);
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "custom/distro-icon"
          "custom/linux"
          "custom/dulP"
          "custom/ddrT"
          "hyprland/workspaces"
          "hyprland/submap"
          "custom/dulT"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "custom/durS"
          "network"
          "custom/ddlS"
          "custom/durT"
          "pulseaudio"
          "custom/ddlT"
          "clock"
        ];
        "custom/linux" = {
          format = "{}";
          exec = "${pkgs.coreutils}/bin/uname -r | ${pkgs.coreutils}/bin/cut -d- -f1";
          interval = 999999999;
        };
        "custom/distro-icon" = {
          format = "";
        };

        "hyprland/window" = { max-length = 50; };
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = false;
          show-special = true;
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "special" = "";
            "default" = "";
          };
        };
        "hyprland/submap" = {
          format = "{}";
          max-length = 8;
          tooltip = false;
        };
        "custom/separator" = {
          format = "/";
          interval = "once";
          tooltip = false;
        };

        "custom/dulP" = {
          format = "";
          tooltip = false;
        };
        "custom/durP" = {
          format = "";
          tooltip = false;
        };
        "custom/durS" = {
          format = "";
          tooltip = false;
        };
        "custom/ddlP" = {
          format = "";
          tooltip = false;
        };
        "custom/ddlS" = {
          format = "";
          tooltip = false;
        };
        "custom/dulS" = {
          format = "";
          tooltip = false;
        };
        "custom/ddrT" = {
          format = "";
          tooltip = false;
        };
        "custom/dulT" = {
          format = "";
          tooltip = false;
        };
        "custom/durT" = {
          format = "";
          tooltip = false;
        };
        "custom/ddlT" = {
          format = "";
          tooltip = false;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{icon}  {volume}%   {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "    {volume}%";
          format-source-muted = "  ";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        clock = {
          format = "{:%a %b %d  %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d-%H:%M}";
        };
      }
      {
        layer = "top";
        position = "bottom";
        modules-left = [ "custom/quit" ];
        modules-center = [ "tray" ];
        modules-right = [
          "custom/ddrS"
          "cpu"
          "temperature"
          "custom/dulS"
          "custom/ddrT"
          "memory"
          "custom/dulT"
        ];
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        "custom/ddrS" = {
          format = "";
        };
        "custom/dulS" = {
          format = "";
        };
        "custom/ddrT" = {
          format = "";
        };
        "custom/dulT" = {
          format = "";
        };
        "custom/quit" = {
          format = "";
          on-click = "hyprctl dispatch exit";
          tooltip = false;
        };
      }
    ];
  };
}
