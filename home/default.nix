{ self, ... }:
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
        ];
      };
      common-linux = {
        imports = [
          self.homeModules.common
          #./bash.nix
          #./vscode-server.nix
          ./zsh.nix
          ./kitty.nix
          ./emacs.nix
        ];
      };
    };
  };
}
