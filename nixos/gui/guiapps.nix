{ pkgs, lib, config, ... }:
let
  isX86 = config.nixpkgs.hostPlatform.system == "x86_64-linux";
in {
  imports = [
    #./vscode.nix
  ];

  # Apps I use on desktops and laptops
  environment.systemPackages = with pkgs; [
    # Browsers (cross-platform)
    firefox
    chromium

    # Image viewers
    nomacs
    pcmanfm

    # Productivity (cross-platform)
    libreoffice
    gimp
    inkscape
    mupdf

    # IM (cross-platform)
    element-desktop
    telegram-desktop

    # Torrent / P2P
    transmission_4-gtk

    librsvg
    stdmanpages
    adwaita-icon-theme

    # video pkgs (cross-platform)
    mesa-demos
    vlc
    mpv
    ffmpeg-full
  ] ++ lib.optionals isX86 [
    # x86_64 only packages
    brave
    tor-browser
    discord
    signal-desktop
    slack
    obs-studio
    code-cursor
  ];
}
