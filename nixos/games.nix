{ pkgs, lib, config, ... }:
let
  isX86 = config.nixpkgs.hostPlatform.system == "x86_64-linux";
in {

  environment.systemPackages = with pkgs; [
    #retroarchBare
    #pcsx2
    cabextract
    gamemode
    mangohud
    protontricks
    darkplaces
    #devilutionx
    #factorio
    #openra
    openal
    gzdoom
    steam-tui
    steamcmd
    #lzwolf
    #faforever
    steam-run
    #steamcompmgr
    #spring
    #springLobby
    lutris
    wine
    winetricks
  ];

  programs.steam = lib.mkIf isX86 {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
    #gamescope = true;
    gamescopeSession.enable = true;
  };
  #programs.gamescope.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      libGL
      libGLU
      openssl
      stdenv.cc.cc
    ];
  };
  services.sunshine = {
    enable = true;
    openFirewall = true;
  };
  # fps games on laptop need this
  services.xserver.libinput.touchpad.disableWhileTyping = false;
  services.xserver.libinput.mouse.disableWhileTyping = false;
  services.xserver.libinput.touchpad.tappingDragLock = false;
  services.xserver.libinput.mouse.tappingDragLock = false;
  services.xserver.libinput.mouse.tapping = false;

  # services.minetest-server = {
  #   enable = true;
  #   gameId = "voxelibre";
  # };
  #services.xserver.windowManager.steam = { enable = true; };

  # 32-bit support needed for steam
  #hardware.opengl.driSupport = true;
  #hardware.opengl.driSupport32Bit = true;

  hardware.pulseaudio.support32Bit = lib.mkIf isX86 true;

  # better for steam proton games
  #systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  # improve wine performance
  environment.sessionVariables = { WINEDEBUG = "-all"; };
}
