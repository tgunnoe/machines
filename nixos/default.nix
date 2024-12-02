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
        #inputs.nur.nixosModules.nur
        #({ config, ... }:{
        #  home-manager.sharedModules = [
        #    config.nur.repos.rycee.hmModules.emacs-init
        #  ];
        #})
      ];

      my-home = {
        users.users.${config.people.myself} = {
          isNormalUser = true;
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
        self.nixosModules.home-manager
        #self.nur.nixosModules.nur
        self.nixosModules.my-home
        self.nixosModules.common
        ./self-ide.nix
        ./ssh-authorize.nix
        ./current-location.nix
        #./android.nix
        ./devices.nix
        #./games.nix
        #./music.nix
        ./audio.nix
        ./misc.nix
        #./harden.nix
        #./cryptocurrency.nix
        #./virtualization.nix
      ];
    };
  };
}
