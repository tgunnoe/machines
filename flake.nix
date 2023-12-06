{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-pi4.url = "github:nixos/nixpkgs?rev=29339c1529b2c3d650d9cf529d7318ed997c149f";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    ragenix.url = "github:yaxitech/ragenix";

    hardware.url = "github:nixos/nixos-hardware";
    hardware-pi4.url = "github:nixos/nixos-hardware?rev=ca29e25c39b8e117d4d76a81f1e229824a9b3a26";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-match.url = "github:srid/nixpkgs-match";
    nuenv.url = "github:DeterminateSystems/nuenv";
    devour-flake.url = "github:srid/devour-flake";
    devour-flake.flake = false;
    nur.url = "github:nix-community/nur";

    emacs.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" "x86_64-linux" ];
      imports = [
        inputs.nixos-flake.flakeModule
        ./users
        ./home
        ./nixos
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
            ];
          };
        };

        perSystem = { self', system, pkgs, lib, config, inputs', ... }: {
          packages.default = self'.packages.activate;
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.alejandra
              #pkgs.sops
              #pkgs.ssh-to-age
              # (
              #   let nixosConfig = self.nixosConfigurations.actual;
              #   in nixosConfig.config.jenkins-nix-ci.nix-prefetch-jenkins-plugins pkgs
              # )
            ];
          };
          formatter = pkgs.alejandra;
        };
      };
    };
}
