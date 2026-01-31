{ config, lib, pkgs, ... }:
let
  # Monitor descriptions from hyprctl monitors (portable across ports)
  monitor34 = "desc:Beihai Century Joint Innovation Technology Co.Ltd 34CHR";
  monitor49 = "desc:Monoprice.Inc 43305 0000000000000";
in
{
  imports = [
    ./waybar.nix
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    # Wayland utilities
    grim
    slurp
    wl-clipboard
    wlr-randr
    wdisplays
    waypipe

    # Launcher and notifications
    wofi
    mako

    # Clipboard manager
    clipman

    # Screen recording
    wf-recorder

    # Image viewer
    imv

    # Audio control
    pamixer
    pavucontrol

    # Qt Wayland support
    qt5.qtwayland

    # Terminal
    ghostty
  ];

  wayland.windowManager.hyprland = {
    enable = lib.mkDefault false;  # Enable per-machine
    xwayland.enable = true;

    settings = {
      # Monitor configuration
      # 34" on left, 49" on right at 5120x1440@120Hz
      monitor = [
        "${monitor34}, 3440x1440@144, 0x0, 1"
        "${monitor49}, 5120x1440@120, 3440x0, 1"
        ", preferred, auto, 1"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        # No variant - keyboard is hardware Dvorak
        kb_options = "ctrl:nocaps";
        follow_mouse = 1;
        sensitivity = 0;
      };

      # General settings
      general = {
        gaps_in = 10;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(bb00ccee) rgba(880033ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "master";
        allow_tearing = false;
      };

      # Master layout - 50/50 split
      master = {
        new_status = "slave";  # New windows go to stack, not master
        mfact = 0.5;
        new_on_top = true;
        inherit_fullscreen = true;
      };

      # Decoration - transparency, blur, rounding
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          new_optimizations = true;
          xray = false;
        };
        shadow = {
          enabled = true;
          range = 15;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
          "specialWorkspace, 1, 4, default, slidevert"
        ];
      };

      # Misc settings including window swallowing
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        enable_swallow = true;
        swallow_regex = "^(ghostty|kitty|Alacritty|foot|wezterm)$";
        swallow_exception_regex = "^(wev|pulsemixer|htop|nvtop)$";
      };

      # Workspace rules - bind workspaces to monitors
      workspace = [
        # 34" monitor - workspaces 1-4
        "1, monitor:${monitor34}, default:true"
        "2, monitor:${monitor34}"
        "3, monitor:${monitor34}"
        "4, monitor:${monitor34}"
        # 49" monitor - workspaces 5-8
        "5, monitor:${monitor49}, default:true"
        "6, monitor:${monitor49}"
        "7, monitor:${monitor49}"
        "8, monitor:${monitor49}"
      ];

      # Window rules
      windowrulev2 = [
        # 80% opacity for all windows by default
        "opacity 0.8 0.8, class:.*"

        # Full opacity for media and browsers
        "opacity 1.0 1.0, class:^(mpv)$"
        "opacity 1.0 1.0, class:^(vlc)$"
        "opacity 1.0 1.0, class:^(imv)$"
        "opacity 1.0 1.0, class:^(firefox)$"
        "opacity 1.0 1.0, class:^(chromium)$"
        "opacity 1.0 1.0, class:^(brave)$"

        # Dropdown terminal
        "float, class:^(dropdown-terminal)$"
        "size 100% 40%, class:^(dropdown-terminal)$"
        "move 0 0, class:^(dropdown-terminal)$"
        "workspace special:dropdown, class:^(dropdown-terminal)$"

        # Steam friends list floats
        "float, class:^(steam)$, title:^(Friends List)$"

        # Pavucontrol floats
        "float, class:^(pavucontrol)$"
      ];

      # Layer rules for wofi blur
      layerrule = [
        "blur, wofi"
        "ignorezero, wofi"
      ];

      # Keybindings
      "$mod" = "SUPER";
      "$terminal" = "kitty";

      bind = [
        # Window management
        "$mod SHIFT, apostrophe, killactive"
        "$mod SHIFT, space, togglefloating"
        "$mod, apostrophe, togglesplit"
        "$mod, u, fullscreen, 1"  # Maximize (keep gaps/bar)
        "$mod SHIFT, u, fullscreen, 0"  # True fullscreen

        # Applications
        "$mod, Return, exec, $terminal"
        "$mod, d, exec, wofi --show drun"
        "$mod, e, exec, emacsclient -c -n -e '(switch-to-buffer nil)'"
        "$mod SHIFT, l, exec, hyprlock"

        # Dropdown terminal
        ", grave, togglespecialworkspace, dropdown"
        "$mod SHIFT, grave, exec, ghostty --class=dropdown-terminal"

        # Focus movement (Dvorak: b=left, n=down, p=up, f=right)
        "$mod, b, movefocus, l"
        "$mod, n, movefocus, d"
        "$mod, p, movefocus, u"
        "$mod, f, movefocus, r"

        # Window movement
        "$mod SHIFT, b, movewindow, l"
        "$mod SHIFT, n, movewindow, d"
        "$mod SHIFT, p, movewindow, u"
        "$mod SHIFT, f, movewindow, r"

        # Workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"

        # Move window to workspace (follow)
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"

        # Move window to workspace (silent - don't follow)
        "$mod CTRL, 1, movetoworkspacesilent, 1"
        "$mod CTRL, 2, movetoworkspacesilent, 2"
        "$mod CTRL, 3, movetoworkspacesilent, 3"
        "$mod CTRL, 4, movetoworkspacesilent, 4"
        "$mod CTRL, 5, movetoworkspacesilent, 5"
        "$mod CTRL, 6, movetoworkspacesilent, 6"
        "$mod CTRL, 7, movetoworkspacesilent, 7"
        "$mod CTRL, 8, movetoworkspacesilent, 8"

        # Workspace navigation
        "$mod, x, workspace, previous"
        "$mod CTRL, f, workspace, e+1"
        "$mod CTRL, b, workspace, e-1"

        # Reload config
        "$mod SHIFT, c, exec, hyprctl reload"
        "$mod SHIFT, r, exec, pkill waybar; waybar &"

        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"
      ];

      # Repeating binds (hold to repeat)
      binde = [
        # Volume control
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ];

      # Non-repeating media keys
      bindl = [
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Brightness (if on laptop)
      bindle = [
        ", XF86MonBrightnessUp, exec, light -A 10"
        ", XF86MonBrightnessDown, exec, light -U 10"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Startup applications
      exec-once = [
        "waybar"
        "mako"
        "wl-paste -t text --watch clipman store"
        "[workspace special:dropdown silent] kitty --class=dropdown-terminal"
      ];
    };

    extraConfig = ''
      # Environment variables for Wayland
      env = QT_QPA_PLATFORM,wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = SDL_VIDEODRIVER,wayland
      env = _JAVA_AWT_WM_NONREPARENTING,1
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
    '';
  };

  # Mako notification daemon
  services.mako = {
    enable = true;
    backgroundColor = "#00000099";
    borderColor = "#bb00ccD9";
    borderSize = 3;
    progressColor = "source #8BA59B00";
    textColor = "#ffffff";
    defaultTimeout = 10000;
    font = "DejaVu Sans 11";
    groupBy = "app-name";
    maxVisible = 3;
    sort = "-priority";
  };

  # Gammastep for night light
  services.gammastep = {
    enable = true;
    latitude = 38.0;
    longitude = -80.0;
  };
}
