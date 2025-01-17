{ flake, config, pkgs, lib, ... }: {

  users.users.${flake.config.people.myself}.shell = pkgs.zsh;
  programs.zsh.enable = true;
  documentation.dev.enable = true;
  programs.bash = {
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };
  environment = {
    sessionVariables = {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
      LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
      EDITOR = "emacsclient -nw";
      VISUAL = "emacsclient -nw";
      MOZ_ENABLE_WAYLAND = "1";
      #XDG_CURRENT_DESKTOP = "sway";
    };
    systemPackages = with pkgs; [
      #python3

      binutils
      coreutils
      curl
      direnv
      dmidecode
      dnsutils
      dosfstools
      encfs
      fd
      git

      gptfdisk
      iputils
      jq
      manix
      moreutils
      lsof
      nix-index
      nmap
      openssl
      pwgen
      ripgrep
      skim
      tealdeer
      screen
      inetutils
      utillinux
      whois
      xdg-utils

      bat
      bzip2
      #devshell.cli
      eza
      gitAndTools.hub
      gzip
      lrzip
      p7zip
      procs
      skim
      unrar
      unzip

      iproute2
      protonvpn-cli_2

      appimage-run
      cntr

      #libbitcoin-explorer
      wf-recorder
      boost
      bottom
      #clang
      cmake
      encfs
      file

      parted
      gcc
      git-filter-repo
      gnumake
      gnupg
      gpgme

      #go
      #gopls
      #gopass
      go-2fa
      imagemagick
      less
      ncdu
      neofetch

      #Nix-related
      cachix
      nix-serve
      nixpkgs-review
      nil

      #nodejs
      #yarn
      libusb1

      #texlive.combined.scheme-full
      pandoc
      #orgtoinvoice
      sshfs
      pkg-config
      rubber
      sqlite
      tig
      tokei
      tree
      viu
      wget
      #youtube-dl
      #lmms
      #fluidsynth
      #audacity
      obs-studio
      #platformio
      #obs-wlrobs






    ];
    shellAliases =
      let ifSudo = lib.mkIf config.security.sudo.enable;
      in
      {
        # quick cd
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # git
        g = "git";

        # grep
        grep = "rg";
        gi = "grep -i";

        # internet ip
        myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';

        # sudo
        s = ifSudo "sudo -E ";
        si = ifSudo "sudo -i";
        se = ifSudo "sudoedit";

        # top
        top = "btm";

        # systemd
        ctl = "systemctl";
        stl = ifSudo "s systemctl";
        utl = "systemctl --user";
        ut = "systemctl --user start";
        un = "systemctl --user stop";
        up = ifSudo "s systemctl start";
        dn = ifSudo "s systemctl stop";
        jtl = "journalctl";

      };
  };
}
