{ self, config, inputs, ... }:

{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      # NixOS modules that are known to work on nix-darwin.
      common.imports = [
        ./nix.nix
        ./caches
      ];

      my-home = {
        users.users.${config.people.myself}.isNormalUser = true;
        home-manager.users.${config.people.myself} = {
          imports = [
            self.homeModules.common-linux
          ];
        };
        home-manager.sharedModules = [
          #inputs.nur.repos.rycee.hmModules.emacs-init
        ];
      };

      default.imports = [
        self.nixosModules.home-manager
        #self.nixosModules.nur
        self.nixosModules.my-home
        self.nixosModules.common
        ./self-ide.nix
        ./ssh-authorize.nix
        ./current-location.nix
      ];
    };
  };
}
