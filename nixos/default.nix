{ self, config, inputs, ... }:

{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      # NixOS modules that are known to work on nix-darwin.
      common.imports = [
        ./nix.nix
        ./caches
        ./gui
        ./terminal.nix
      ];

      my-home = {
        users.users.${config.people.myself} = {
          isNormalUser = true;
          hashedPassword = config.people.users.${config.people.myself}.hashedPassword;
          openssh.authorizedKeys.keys = config.people.users.${config.people.myself}.sshKeys;
          extraGroups = [
            "adbusers"
            "wheel"
            "input"
            "networkmanager"
            "libvirtd"
            "video"
            "taskd"
            "docker"
            "plugdev"
            "seat"
            "vboxusers"
          ];
        };
        home-manager.users.${config.people.myself} = {
          imports = [
            self.homeModules.default
          ];
        };
      };
      default.imports = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; flake = self; people = config.people; };
        }
        #self.nur.nixosModules.nur
        self.nixosModules.my-home
        self.nixosModules.common
        ./self-ide.nix
        ./ssh-authorize.nix
        ./current-location.nix
        ./android.nix
        ./devices.nix
        ./games.nix
        ./education.nix
        ./music.nix
        ./audio.nix
        ./misc.nix
        ./harden.nix
        ./cryptocurrency.nix
        ./virtualization.nix
        #./nebula.nix
      ];
    };
  };
}
