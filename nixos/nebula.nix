{ config, pkgs, lib, ... }:

{
  # SOPS configuration
  sops = {
    defaultSopsFile = ../secrets/nebula.yaml;
    defaultSopsFormat = "yaml";
    
    # Use SSH host key for decryption
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    
    # Define secrets
    secrets = {
      "nebula-ca-crt" = { 
        mode = "0440";
        owner = "nebula-home";
        group = "nebula-home";
      };
      "nebula-host-crt" = { 
        mode = "0440";
        owner = "nebula-home";
        group = "nebula-home";
      };
      "nebula-host-key" = { 
        mode = "0440";
        owner = "nebula-home";
        group = "nebula-home";
      };
      "nebula-public-ip" = { };
    };
  };

  # Enable Nebula networking
  services.nebula.networks.home = {
    enable = true;
    
    # Nebula will bind to this port
    listen = {
      host = "0.0.0.0";
      port = 4242;
    };

    # Static host mappings - temporarily hardcode until placeholder works
    staticHostMap = {
      "192.168.100.1" = [ "152.86.88.202:4242" ];
    };

    # Lighthouse configuration
    lighthouses = [ "192.168.100.1" ];
    
    # This machine's role - will be overridden per host
    isLighthouse = false;
    
    # Relay configuration for NAT traversal
    relays = [ "192.168.100.1" ];

    # Firewall rules for Nebula overlay network
    firewall = {
      inbound = [
        {
          port = 22;
          proto = "tcp";
          groups = [ "laptop" "admin" ];
        }
        {
          port = "any";
          proto = "icmp";
          groups = [ "laptop" "admin" ];
        }
      ];
      
      outbound = [
        {
          port = "any";
          proto = "any";
          groups = [ "laptop" "admin" ];
        }
      ];
    };

    # Certificate and key paths from SOPS
    ca = config.sops.secrets."nebula-ca-crt".path;
    cert = config.sops.secrets."nebula-host-crt".path;
    key = config.sops.secrets."nebula-host-key".path;
  };

  # Override nebula service to run as root (temporary fix for sops permissions)
  systemd.services."nebula@home" = {
    serviceConfig = {
      User = lib.mkForce "root";
      Group = lib.mkForce "root";
    };
  };

  # Open firewall for Nebula
  networking.firewall = {
    allowedUDPPorts = [ 4242 ];
    trustedInterfaces = [ "nebula.home" ];
  };
}
