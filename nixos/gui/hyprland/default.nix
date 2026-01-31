{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hyprlock
    hypridle
    hyprpaper
    ghostty
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # PAM configuration for hyprlock
  security.pam.services.hyprlock = {};

  # XDG portal configuration for Hyprland
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
