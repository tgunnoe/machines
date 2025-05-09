{ config, lib, pkgs, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  imports = [ ./waybar.nix ];

  home.packages = with pkgs; [
    swayidle
    swaylock # screen locking
    grim
    sway-contrib.grimshot
    slurp
    kanshi
    imv
    wf-recorder
    wl-clipboard
    dbus-sway-environment
    configure-gtk
    pamixer

    autotiling
    #flashfocus
    i3-swallow
    swaykbdd
    cage

    swaybg
    clipman
    drm_info
    #gebaar-libinput # libinput gestures utility
    waypipe
    wdisplays
    wlr-randr
    wofi

    #xdg-desktop-portal-wlr
    dmenu-wayland
    qt5.qtwayland
    #volnoti

  ];
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # package = pkgs.sway.overrideDerivation (oldAttrs: {
    #   name = "sway-1.7-pr6484";
    #   patches = oldAttrs.patches ++ [
    #     (
    #       pkgs.fetchpatch {
    #         name = "fix-segfault.patch";
    #         url = "https://github.com/swaywm/sway/pull/6484.patch";
    #         sha256 = "iUl8pBpj+vE6gq+WZJTD96/jGU0qNdDZD4WndYZtDUg=";
    #       }
    #     )
    #   ];
    # });
    config = {
      terminal = "${pkgs.kitty}/bin/kitty";
      assigns = {
        "1: web" = [{ class = "^Firefox$"; }];
        "0: extra" = [{ class = "^Firefox$"; window_role = "About"; }];
      };
      workspaceAutoBackAndForth = true;
      bars = [ ];
      window = {
        border = 1;
        hideEdgeBorders = "none";
        commands = [
          {
            command = "opacity 0";
            criteria = {
              app_id = ".*";
            };
          }
          {
            command = "exec ${./fadein.sh}";
            criteria = {
              app_id = ".*";
            };
          }
          {
            command = "exec ${./swallow.py}";
            criteria = {
              app_id = ".*";
            };
          }
          {
            command = "mark fade";
            criteria = {
              app_id = ".*";
            };
          }
          {
            command = "move container to scratchpad";
            criteria = {
              title = "dropdown";
            };
          }
          {
            command = "move absolute position 0 30";
            criteria = {
              title = "dropdown";
            };
          }
          {
            command = "resize set 110 ppt 40 ppt";
            criteria = {
              title = "dropdown";
            };
          }

        ];
      };
      # fonts = {
      #   names = [ "DejaVu Sans Mono" "FontAwesome5Free" "Nerdfonts" ];
      #   style = "Bold Semi-Condensed";
      #   size = 12.0;
      # };
      gaps = {
        smartBorders = "on";
      };
      input = {
        "*" = {
         xkb_variant = "dvorak";
        };
        "6127:24801:TrackPoint_Keyboard_II" = {
          xkb_layout = "us";
          xkb_variant = "dvorak,nodeadkeys";
          xkb_options = "ctrl:nocaps";
          middle_emulation = "enabled";
          tap = "enabled";
          click_method = "none";
          drag_lock = "disabled";
          scroll_method = "on_button_down";
          scroll_button = "disable";
        };
        "6127:24814:Lenovo_TrackPoint_Keyboard_II" = {
          xkb_layout = "us";
          xkb_variant = "dvorak,nodeadkeys";
          xkb_options = "ctrl:nocaps";
          middle_emulation = "enabled";
          tap = "enabled";
          click_method = "none";
          drag_lock = "disabled";
          scroll_method = "on_button_down";
          scroll_button = "disable";
        };
      };
      # down = "n";
      # up = "p";
      # right = "f";
      # left = "b";
      floating = {
        border = 1;
        criteria = [
          { class = "Pavucontrol"; }
        ];
      };
      modifier = "Mod4";
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+Ctrl+1" = "move container to workspace 1";
          "${modifier}+Ctrl+2" = "move container to workspace 2";
          "${modifier}+Ctrl+3" = "move container to workspace 3";
          "${modifier}+Ctrl+4" = "move container to workspace 4";
          "${modifier}+Ctrl+5" = "move container to workspace 5";
          "${modifier}+Ctrl+6" = "move container to workspace 6";
          "${modifier}+Ctrl+7" = "move container to workspace 7";
          "${modifier}+Ctrl+8" = "move container to workspace 8";

          "${modifier}+l" = "${pkgs.swaylock}/bin/swaylock --config ${./swaylock-config}";

          "${modifier}+Shift+1" = "move container to workspace 1; workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2; workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3; workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4; workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5; workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6; workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7; workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8; workspace 8";
          "${modifier}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
          "${modifier}+Shift+apostrophe" = "mark quit; exec ${./fadeout.sh}";
          "${modifier}+apostrophe" = "split toggle";
          "${modifier}+h" = "split h;exec notify-send 'tile horizontally'";
          "${modifier}+v" = "split v;exec notify-send 'tile vertically'";
          "${modifier}+x" = "workspace back_and_forth";
          "${modifier}+Shift+x" = "move container to workspace back_and_forth; workspace back_and_forth";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -b 'Yes, exit sway' 'swaymsg exit'";
          "${modifier}+Ctrl+f" = "workspace next";
          "${modifier}+Ctrl+b" = "workspace prev";
          "grave" = "scratchpad show";
          "${modifier}+a" = "focus parent";
          "${modifier}+Shift+s" = "sticky toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+u" = "fullscreen toggle";
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+r" = "mode \"resize\"";
          "${modifier}+d" = "exec --no-startup-id ${pkgs.wofi}/bin/wofi --show run";

          "${modifier}+b" = "focus left";
          "${modifier}+n" = "focus down";
          "${modifier}+p" = "focus up";
          "${modifier}+f" = "focus right";
          "${modifier}+comma" = "layout tabbed";
          "${modifier}+y" = "layout toggle split";

          "${modifier}+e" = "exec ${config.wayland.windowManager.sway.config.terminal} emacsclient -nw -e '(switch-to-buffer nil)'";
          "${modifier}+Ctrl+m" = "exec pavucontrol";

          XF86MonBrightnessUp = "exec \"light -A 10; notify-send 'brightness up'\"";
          XF86MonBrightnessDown = "exec \"light -U 10; notify-send 'brightness down'\"";
          XF86AudioMute = "exec pamixer -t";
          XF86AudioRaiseVolume = "exec pamixer -i 5 #to increase 5%";
          XF86AudioLowerVolume = "exec pamixer -d 5 #to decrease 5%";
          "${modifier}+Shift+b" = "move left";
          "${modifier}+Shift+n" = "move down";
          "${modifier}+Shift+p" = "move up";
          "${modifier}+Shift+f" = "move right";
        };
      modes =
        let
          mode_system = "(l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown";
        in
        {
          # TODO: Fill this in
          mode_system = {
            # l = "";
            # s = "";
            # u = "";
            # e = "";
            # h = "";
            # r = "";
            "Shift+s" = "exec --no-startup-id swaymsg exit";
            Escape = "mode default";
            Return = "mode default";
          };
          resize = {
            Down = "resize grow height 10 px";
            Escape = "mode default";
            Left = "resize shrink width 10 px";
            Return = "mode default";
            Right = "resize grow width 10 px";
            Up = "resize shrink height 10 px";
            h = "resize shrink width 10 px";
            t = "resize grow height 10 px";
            n = "resize shrink height 10 px";
            s = "resize grow width 10 px";
          };
        };
      seat = {
        "*" = {
          hide_cursor = "when-typing enable";
          xcursor_theme = "Adwaita 24";
        };
      };
      startup = [
        { command = "systemctl --user restart waybar"; always = true; }
        { command = "${pkgs.autotiling}/bin/autotiling"; }
        { command = "${pkgs.swaykbdd}/bin/swaykbdd"; }
        { command = "${pkgs.flashfocus}/bin/flashfocus"; }
        { command = "${pkgs.mako}/bin/mako"; always = true; }
        { command = "${config.wayland.windowManager.sway.config.terminal} --title='dropdown'"; }
        { command = "${config.wayland.windowManager.sway.config.terminal} --title='dropdown'"; }
        { command = "${dbus-sway-environment}"; }
        { command = "${configure-gtk}"; }
        # {
        #   command = ''
        #     ${pkgs.swayidle}/bin/swayidle -w \
        #       timeout 300 "${pkgs.swaylock}/bin/swaylock --config ${./swaylock-config}" \
        #       timeout 600 'swaymsg "output * dpms off"' \
        #       after-resume 'swaymsg "output * dpms on"' \
        #       before-sleep "${pkgs.swaylock}/bin/swaylock --config ${./swaylock-config}"
        #   '';
        # }
      ];
    };
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  programs.mako = {
    enable = true;
    backgroundColor = "#00000099";
    borderColor = "#0D6678D9";
    borderSize = 3;
    progressColor = "source #8BA59B00";
    textColor = "#ffffff";
    defaultTimeout = 5000;
    font = "DejaVu Sans 11";
    groupBy = "app-name";
    maxVisible = 3;
    sort = "-priority";
  };

  services.gammastep = {
    latitude = 38.0;
    longitude = -80.0;
    enable = true;
  };
  # services.swayidle = {
  #   enable = true;
  #   events = [
  #     { event = "before-sleep"; command = "swaylock"; }
  #     { event = "after-resume"; command = "swaymsg 'output * dpms on'"; }
  #   ];
  #   timeouts = [
  #     { timeout = 300; command = "swaylock -fF"; }
  #     { timeout = 600; command = "swaymsg 'output * dpms off'"; }
  #   ];
  # };
  programs.swaylock.settings = {
    screenshots = true;
    clock = true;
    indicator = true;
    ignore-empty-password = true;
    indicator-radius = 200;
    indicator-thickness = 15;
    effect-pixelate = 5;
    effect-greyscale = true;
    effect-vignette = "0.5:0.5";
    ring-color = "bb00cc";
    key-hl-color = "880033";
    line-color = "00000000";
    inside-color = "00000088";
    separator-color = "00000000";
    grace = 10;
    fade-in = 0.2;
  };
}
