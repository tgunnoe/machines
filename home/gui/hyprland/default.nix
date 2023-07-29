{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = false;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };
}
