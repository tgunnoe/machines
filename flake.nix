{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-match.url = "github:srid/nixpkgs-match";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devour-flake.url = "github:srid/devour-flake";
    devour-flake.flake = false;
    nur.url = "github:nix-community/nur";

    emacs.url = "github:nix-community/emacs-overlay";
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
          sietch-tabr = self.nixos-flake.lib.mkLinuxSystem "aarch64-linux" {
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
