{ config, pkgs, ... }:

# let
#   myXmonadProject = ./xmonad-srid;
# in
{
  environment.systemPackages = with pkgs; [
    arandr
    autorandr
  ];
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };

}
