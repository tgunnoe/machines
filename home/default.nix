{ self, config, lib, inputs, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "22.11";
        imports = [
          ./terminal.nix
          ./git.nix
          ./direnv.nix
          #./nushell.nix
          #./powershell.nix
          ./kitty.nix
          ./emacs.nix
          ./zellij.nix

        ];
      };
      default = { pkgs, ...}: {
        imports = [
          self.homeModules.common
          inputs.nix-doom-emacs.hmModule
          ./gui
          ./zsh.nix
        ];
        # programs.doom-emacs = {
        #   enable = true;
        #   doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el
        #   # and packages.el files
        # };
        #programs.emacs.enable = true;
        programs.git.enable = true;
        home.packages = with pkgs; [
          grim
          slurp
          kanshi
          cage
          clipman
          waypipe
          wdisplays
          wdomirror
          wlr-randr
          xdg-desktop-portal-wlr
          qt5.qtwayland
        ];
      };
    };
  };
}
