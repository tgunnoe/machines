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
    
    nur.url = "github:nix-community/nur";

    xfce-winxp-tc = {
      url = "github:mrtipson/xfce-winxp-tc/cleanup";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ config, ... }: {
      systems = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" ];
      imports = [
        ./users
        ./home
        ./nixos
        ./darwin
        ./shells
      ];
      flake = {
        nixosConfigurations = {
          sietch-tabr = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; flake = self; people = config.people; };
            modules = [
              ./systems/sietch-tabr.nix
              self.nixosModules.default
            ];
          };
          chapterhouse = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; flake = self; people = config.people; };
            modules = [
              { nixpkgs.hostPlatform = "x86_64-linux"; }
              ./systems/chapterhouse.nix
              self.nixosModules.default
            ];
          };
          caladan = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; flake = self; people = config.people; };
            modules = [
              { nixpkgs.hostPlatform = "x86_64-linux"; }
              ./systems/caladan.nix
              self.nixosModules.default
            ];
          };
          arrakis = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; flake = self; people = config.people; };
            modules = [
              { nixpkgs.hostPlatform = "x86_64-linux"; }
              ./systems/arrakis.nix
              self.nixosModules.default
              inputs.hardware.nixosModules.framework-11th-gen-intel
              inputs.ragenix.nixosModules.age
            ];
          };
        };
        darwinConfigurations = {
          geidi-prime = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = { inherit inputs; flake = self; people = config.people; };
            modules = [
              self.darwinModules.default
            ];
          };
        };
      };
    });
}
