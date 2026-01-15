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
    podman.enable = true;
    containers.enable = true;
    waydroid.enable = true;
    #docker.enable = true;
    #virtualbox.host.enable = true;
    #virtualbox.host.enableExtensionPack = true;

  };
  networking.firewall.trustedInterfaces = [ "waydroid0" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    virt-manager
    distrobox
    #vagrant
  ];
  programs.dconf.enable = true;
  #environment.shellAliases.docker = "podman";

  # environment.sessionVariables = {
  #   VAGRANT_DEFAULT_PROVIDER = "libvirt";
  # };
}
