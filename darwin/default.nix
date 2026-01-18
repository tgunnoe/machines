{ self, config, inputs, ... }:

{
  # Configuration specific to macOS/Darwin systems
  flake = {
    darwinModules = {
      default.imports = [
        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnsupportedSystem = true;
          system.stateVersion = 4;
          system.primaryUser = config.people.myself;

          # Determinate Nix manages the Nix installation
          nix.enable = false;

          users.users.${config.people.myself} = {
            home = "/Users/${config.people.myself}";
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; flake = self; };
            users.${config.people.myself} = {
              imports = [ self.homeModules.darwin ];
            };
          };
        }
      ];
    };
  };
}
