{ pkgs, ... }: {
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

    containers.enable = true;
    waydroid.enable = true;
    docker.enable = true;
  };
  networking.firewall.trustedInterfaces = [ "waydroid0" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    virt-manager
  ];
  programs.dconf.enable = true;
  #environment.shellAliases.docker = "podman";

  # environment.sessionVariables = {
  #   VAGRANT_DEFAULT_PROVIDER = "libvirt";
  # };
}
