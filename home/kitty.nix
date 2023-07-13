{
  programs.kitty = {
    enable = true;
    keybindings = {
      "kitty_mod+e" = "kitten hints"; # https://sw.kovidgoyal.net/kitty/kittens/hints/
    };
    settings = {
      scrollback_lines = 10000;
      background_opacity = "0.7";
      #      window_padding_width = "10.0";
      wheel_scroll_multiplier = "15.0";
      touch_scroll_multiplier = "10.0";
      font_size = "8.0";
      enable_audio_bell = false;
      confirm_os_window_close = "0";
    };
    theme = "Ayu";
  };
}
