# Educational software for kids
{ pkgs, lib, config, ... }:
let
  isX86 = config.nixpkgs.hostPlatform.system == "x86_64-linux";
in {
  environment.systemPackages = with pkgs; [
    # Programming / Coding education
    thonny          # Python IDE for beginners
    kdePackages.kturtle  # Logo programming for kids
    # scratch is not available in nixpkgs, use scratch-editor from flatpak

    # Typing
    tuxtype         # Typing tutor with Tux

    # Art / Creativity
    tuxpaint        # Drawing program for kids

    # Math / Science
    gcompris        # Educational suite for kids 2-10
    #kdePackages.kalzium  # Periodic table
    kstars   # Desktop planetarium
    kdePackages.marble   # Virtual globe and world atlas
    kdePackages.step     # Physics simulator
    kdePackages.kgeography  # Geography learning

    # Music
    kdePackages.minuet   # Music education

    # Language learning
    kdePackages.kanagram  # Letter order game
    kdePackages.khangman  # Hangman game for learning
    kdePackages.kwordquiz # Vocabulary trainer
    kdePackages.parley    # Vocabulary trainer

    # General education
    kdePackages.ktouch    # Touch typing tutor
    kdePackages.kbruch    # Fractions practice

    # 3D / Building
    leocad          # Virtual LEGO CAD
  ] ++ lib.optionals isX86 [
    # x86_64 only educational packages
    codeblocks      # C/C++ IDE
  ];
}
