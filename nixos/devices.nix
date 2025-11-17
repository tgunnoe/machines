{ pkgs, ... }:
{
  services.udev.packages = [
    pkgs.logitech-udev-rules
  ];
  environment.systemPackages = with pkgs; [
    pkgs.solaar
    lm_sensors
    radeontop
    clinfo
    #glxinfo
  ];
}
