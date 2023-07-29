{ pkgs, ... }:
{
  services.flatpak.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.tor.enable = true;
  services.tor.client.enable = true;
}
