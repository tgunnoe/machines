{ flake, pkgs, lib, ... }:

{
  nixpkgs = {
    config = {
      allowBroken = false;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    overlays = [
      #flake.inputs.nuenv.overlays.nuenv
      (self: super: { devour-flake = self.callPackage flake.inputs.devour-flake { }; })
    ];
  };

  nix = {
    package = pkgs.nixVersions.latest; # Need 2.15 for bug fixes
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    #gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      # Nullify the registry for purity.
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      netrc-file = /home/${flake.config.people.myself}/.netrc;
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      sandbox = true;
      trusted-users = [ "@wheel" "tgunnoe" ];
    };
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };
}
