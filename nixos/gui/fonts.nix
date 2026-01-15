{ config, lib, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      monospace = [ "FiraCode Nerd Font Mono" "Ubuntu Mono" ];
      sansSerif = [ "Ubuntu" ];
    };
    packages = with pkgs; [
      # NOTE: Some fonts may break colour emojis in Chrome
      # cf. https://github.com/NixOS/nixpkgs/issues/69073#issuecomment-621982371
      # If this happens , keep noto-fonts-emoji and try disabling others (nerdfonts, etc.)
      #noto-fonts-emoji
      fira-code
      cascadia-code
      # Nerd fonts are now individual packages
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.hack
      powerline-fonts
      b612
    ];
  };
}
