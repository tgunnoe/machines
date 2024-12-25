{ pkgs, ...}:

{
  networking.wireless.networks = {
    galaxian5g = {                   # SSID with no spaces or special characters
      psk = "jeep3R!2788";           # (password will be written to /nix/store!)
    };
    genesis = {                   # SSID with no spaces or special characters
      psk = "jeep3R!2788";           # (password will be written to /nix/store!)
    };
    Kaitain = {                   # SSID with no spaces or special characters
      psk = "12345678";           # (password will be written to /nix/store!)
    };
  };

}
