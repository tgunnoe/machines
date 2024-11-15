{ pkgs, ... }: {
  imports = [
    #./vscode.nix
  ];

  # Apps I use on desktops and laptops
  environment.systemPackages = with pkgs; [
    #brave
    firefox-wayland
    #chromium
    #tor-browser-bundle-bin
    # onlyoffice-bin
    #obsidian
    nomacs
    #nyxt
    pcmanfm

    # Productivity
    #libreoffice
    gimp
    #inkscape
    mupdf

    # IM
    #discord
    #element-desktop
    #signal-desktop
    #slack
    tdesktop
    #gomuks

    #_1password
    #_1password-gui

    # Torrent / P2P
    qbittorrent
    transmission-gtk

    librsvg

    libsForQt5.qtstyleplugins
    #man-pages

    qt5.qtgraphicaleffects
    stdmanpages

    gnome.adwaita-icon-theme
    # video pkgs
    glxinfo
    vlc
    #untrunc
    mpv
    #obs-studio
    ffmpeg-full
    #simplescreenrecorder
    stremio

    # X stuff
    # caffeine-ng
    # xorg.xdpyinfo
    # xorg.xrandr
    # xclip
    # xsel
    # arandr
  ];
}
