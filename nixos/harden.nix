{ people, ... }: {

  # Firewall
  networking.firewall.enable = true;

  security.sudo.execWheelOnly = true;

  security.sudo.wheelNeedsPassword = false;
  users.users.${people.myself} = {
    extraGroups = [ "wheel" ];
  };
  security.auditd.enable = true;
  security.audit.enable = true;
  security.polkit.enable = true;

  services = {
    openssh = {
      enable = true;
      challengeResponseAuthentication = false;
      settings.PermitRootLogin = "prohibit-password"; # distributed-build.nix requires it
      settings.PasswordAuthentication = false;
      allowSFTP = true;
      forwardX11 = true;
      startWhenNeeded = true;

    };
    # fail2ban = {
    #   enable = true;
    #   ignoreIP = [
    #     "100.80.93.92" # Tailscale "appreciate"
    #   ];
    # };
  };
  nix.settings.allowed-users = [ "root" "@users" ];
  nix.settings.trusted-users = [ "root" people.myself ];

  users.mutableUsers = false;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
}
