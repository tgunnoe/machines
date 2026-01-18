{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    
    #nur.url = "github:nix-community/nur";

    xfce-winxp-tc = {
      url = "github:mrtipson/xfce-winxp-tc/cleanup";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Raspberry Pi support
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";

    # Deployment tool
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ config, ... }:
    let
      # Default deployment settings - can be overridden per machine
      mkDeployment = name: {
        targetHost = name;
        targetUser = "tgunnoe";
        buildOnTarget = true;
      };

      # Define machines once, use in both nixosConfigurations and colmena
      machines = {
        sietch-tabr = {
          system = "aarch64-linux";
          modules = [
            ./systems/sietch-tabr.nix
            self.nixosModules.default
          ];
        };
        chapterhouse = {
          system = "x86_64-linux";
          modules = [
            ./systems/chapterhouse.nix
            self.nixosModules.default
          ];
        };
        caladan = {
          system = "x86_64-linux";
          modules = [
            ./systems/caladan.nix
            self.nixosModules.default
          ];
          deployment.buildOnTarget = false;
        };
        arrakis = {
          system = "x86_64-linux";
          modules = [
            ./systems/arrakis.nix
            self.nixosModules.default
            inputs.hardware.nixosModules.framework-11th-gen-intel
            inputs.ragenix.nixosModules.age
          ];
        };
        jacurutu = {
          system = "aarch64-linux";
          modules = [
            inputs.raspberry-pi-nix.nixosModules.raspberry-pi
            inputs.raspberry-pi-nix.nixosModules.sd-image
            self.nixosModules.default
            ./systems/jacurutu.nix
          ];
          # Override: cross-compile for Pi instead of building on target
          deployment.buildOnTarget = false;
        };
      };

      # Helper to create nixosSystem from machine definition
      mkNixosSystem = name: machine: inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; flake = self; };
        modules = [
          { nixpkgs.hostPlatform = machine.system; }
        ] ++ machine.modules;
      };

      # Helper to create colmena host from machine definition
      mkColmenaHost = name: machine: { ... }: {
        deployment = (mkDeployment name) // (machine.deployment or {});
        imports = machine.modules;
        nixpkgs.hostPlatform = machine.system;
      };
    in {
      systems = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" ];
      imports = [
        ./users
        ./home
        ./nixos
        ./darwin
        ./shells
      ];
      flake = {
        # Expose people config as a flake output so modules can access it via flake.people
        people = config.people;

        nixosConfigurations = builtins.mapAttrs mkNixosSystem machines;

        darwinConfigurations = {
          geidi-prime = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = { inherit inputs; flake = self; };
            modules = [
              self.darwinModules.default
            ];
          };
        };

        # Colmena deployment configuration
        colmenaHive = inputs.colmena.lib.makeHive self.outputs.colmena;
        colmena = {
          meta = {
            nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
            specialArgs = { inherit inputs; flake = self; };
          };
        } // builtins.mapAttrs mkColmenaHost machines;
      };
    });
}
