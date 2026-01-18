{ pkgs, lib, config, ... }:
let
  isX86 = config.nixpkgs.hostPlatform.system == "x86_64-linux";
in {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = false;
      };
      allowedBridges = [
        "virbr0"
        "virbr1"
      ];
    };
    podman.enable = true;
    containers.enable = true;
    # Waydroid only works well on x86_64 currently
    waydroid.enable = lib.mkIf isX86 true;
  };

  networking.firewall.trustedInterfaces = lib.mkIf isX86 [ "waydroid0" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    virt-manager
    distrobox
  ];

  programs.dconf.enable = true;
}
