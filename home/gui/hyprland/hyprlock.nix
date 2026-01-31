{ pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(187, 0, 204)";  # Magenta ring
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];

      label = [
        # Time
        {
          position = "0, 200";
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"'';
          font_size = 120;
          font_family = "DejaVu Sans Bold";
          color = "rgba(255, 255, 255, 0.9)";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          position = "0, 80";
          monitor = "";
          text = ''cmd[update:43200000] echo "<span>$(date +"%A, %B %d")</span>"'';
          font_size = 24;
          font_family = "DejaVu Sans";
          color = "rgba(255, 255, 255, 0.8)";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
