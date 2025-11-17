{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mpc
    mpd
  ];
  services.mpd = {
    enable = true;
  };
}
