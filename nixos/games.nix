{ pkgs, lib, config, ... }:
let
  isX86 = config.nixpkgs.hostPlatform.system == "x86_64-linux";
  isAarch64 = config.nixpkgs.hostPlatform.system == "aarch64-linux";
in {

  # Cross-platform games (work on both x86_64 and aarch64)
  environment.systemPackages = with pkgs; [
    # Classic game engines/source ports
    gzdoom
    openal
    devilutionx
    fheroes2
    openxcom
    ecwolf
    scummvm
    dosbox-x

    # Strategy games
    openra
    # wargus - currently broken (stratagus cmake issue)
    zeroad

    # Open source games
    superTuxKart
    superTux
    luanti  # formerly minetest

    # Emulators
    libretro.dosbox-pure

    # Tools
    innoextract
  ] ++ lib.optionals isX86 [
    # x86_64 only packages
    cabextract
    gamemode
    mangohud
    protontricks
    darkplaces
    steam-tui
    steamcmd
    steam-run
    lutris
    wine
    winetricks
    theforceengine
    commandergenius
    vcmi
  ] ++ lib.optionals isAarch64 [
    # aarch64 specific packages (if any)
    easyrpg-player
  ];

  # Steam only available on x86_64
  programs.steam = lib.mkIf isX86 {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  # nix-ld for running unpatched binaries
  programs.nix-ld = lib.mkIf isX86 {
    enable = true;
    libraries = with pkgs; [
      zlib
      libGL
      libGLU
      openssl
      stdenv.cc.cc
    ];
  };

  # Sunshine game streaming (x86 only for now)
  services.sunshine = lib.mkIf isX86 {
    enable = true;
    openFirewall = true;
  };

  # Kodi media center / gaming
  services.xserver.desktopManager.kodi = {
    enable = true;
    package = pkgs.kodi-gbm;
  };

  # fps games on laptop need this
  services.libinput.touchpad.disableWhileTyping = false;
  services.libinput.mouse.disableWhileTyping = false;
  services.libinput.touchpad.tappingDragLock = false;
  services.libinput.mouse.tappingDragLock = false;
  services.libinput.mouse.tapping = false;

  # Steam hardware support
  hardware.steam-hardware.enable = lib.mkIf isX86 true;

  # 32-bit audio support for Steam
  services.pulseaudio.support32Bit = lib.mkIf isX86 true;

  # improve wine performance
  environment.sessionVariables = lib.mkIf isX86 { WINEDEBUG = "-all"; };
}
