{ pkgs, ...}:

{
  #sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    #wireplumber.enable = true;
    #media-session.enable = true;
    extraConfig.pipewire."00-increase-buffer" = ''
      context.properties = {
        default.clock.quantum = 2048;  # Try 1024 or 4096 if 2048 doesn't help
        default.clock.min-quantum = 1024;
      }
    '';
  };
  environment.systemPackages = [
    pkgs.pavucontrol
    pkgs.pulsemixer
  ];
}
