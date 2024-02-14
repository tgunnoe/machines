{ pkgs, ... }:
{
  services.udev.packages = [
    pkgs.logitech-udev-rules
  ];
  environment.systemPackages = [
    pkgs.solaar
  ];
}
