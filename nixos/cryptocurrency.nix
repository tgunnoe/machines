{ pkgs, ... }:
{
  services.trezord.enable = true;
  hardware.ledger.enable = true;
}
