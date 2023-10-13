{ pkgs, ... }:
{
  services.dbus.enable = true;
  services.flatpak.enable = true;
  services.tor.enable = true;
  services.tor.client.enable = true;

  programs.firejail.enable = true;
  programs.mtr.enable = true;
  programs.extra-container.enable = true;
  programs.sysdig.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
}
