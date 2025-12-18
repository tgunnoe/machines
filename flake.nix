{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake/ef4921f6af505ee41ccab57b65b99be9cef63886";

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

  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" "x86_64-linux" ];
      imports = [
        inputs.nixos-flake.flakeModule
        ./users
        ./home
        ./nixos
        ./shells
      ];
      flake = {
        nixosConfigurations = {
          sietch-tabr = self.nixos-flake.lib.mkLinuxSystem {
            imports = [
              ./systems/sietch-tabr.nix
              self.nixosModules.default
            ];
          };
          chapterhouse = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              ./systems/chapterhouse.nix
              self.nixosModules.default
            ];
          };
          caladan = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              ./systems/caladan.nix
              self.nixosModules.default
            ];
          };

          arrakis = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              ./systems/arrakis.nix
              self.nixosModules.default
              inputs.hardware.nixosModules.framework-11th-gen-intel
              inputs.ragenix.nixosModules.age
            ];
          };
        };
      };
    };
}
