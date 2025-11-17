{ pkgs, ... }: {
  imports = [
    #./vscode.nix
  ];

  # Apps I use on desktops and laptops
  environment.systemPackages = with pkgs; [
    brave
    firefox
    chromium
    tor-browser
    # onlyoffice-bin
    #obsidian
    nomacs
    #nyxt
    pcmanfm

    # Productivity
    libreoffice
    gimp
    inkscape
    mupdf

    # IM
    discord
    element-desktop
    signal-desktop
    slack
    telegram-desktop
    #gomuks

    #_1password
    #_1password-gui

    # Torrent / P2P
    #qbittorrent
    transmission_4-gtk

    librsvg

    #libsForQt5.qtstyleplugins
    #man-pages

    #qt5.qtgraphicaleffects
    stdmanpages

    adwaita-icon-theme
    # video pkgs
    mesa-demos
    vlc
    #untrunc
    mpv
    obs-studio
    ffmpeg-full
    #simplescreenrecorder
    #stremio

    code-cursor
    # X stuff
    # caffeine-ng
    # xorg.xdpyinfo
    # xorg.xrandr
    # xclip
    # xsel
    # arandr
  ];
}
