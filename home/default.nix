{ self, config, lib, inputs, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "22.11";
        imports = [
	./terminal.nix
          ./git.nix
          ./direnv.nix
          #./nushell.nix
          #./powershell.nix
          ./kitty.nix
          #./emacs.nix
	#          ./zellij.nix

        ];
      };
      default = { pkgs, config, ...}: {

        imports = [
          self.homeModules.common
          inputs.nix-doom-emacs-unstraightened.hmModule
          inputs.plasma-manager.homeModules.plasma-manager
          #./gui
          ./zsh.nix
        ];
        programs.doom-emacs = {
          enable = true;
          doomDir = "${inputs.self}/home/doom.d";
          experimentalFetchTree = true;
          extraPackages = epkgs: with epkgs; [
          #vterm
          #chatgpt-shell
          ];
        };
        programs.plasma = {
          enable = true;

          configFile = {
            "kglobalshortcutsrc" = {
              "org.kde.konsole.desktop" = {
                "_launch" = "Meta+Return,none,Launch Konsole";
              };
              "org.kde.dolphin.desktop" = {
                "_launch" = "none,Meta+E,Dolphin";
              };
              "kwin" = {
                # Move Krohnkite's Set Master to Win+Shift+Enter
                "KrohnkiteSetMaster" = "Meta+Shift+Return,none,Krohnkite: Set master";
                # Win+Q to close window (simpler than trying to use apostrophe)
                "Window Close" = "Meta+Q,Alt+F4,Close Window";
              };
              "services/org.kde.krunner.desktop" = {
                "RunClipboard" = "Alt+Shift+F2,Alt+Shift+F2,Run command on clipboard contents";
                "_launch" = "none,Alt+Space\\tSearch\\tAlt+F2,KRunner";
              };
            };
            "khotkeysrc" = {
              "Data_1" = {
                "DataCount" = "1";
              };
              "Data_1_1" = {
                "Comment" = "Launch Emacs Client";
                "Enabled" = "true";
                "Name" = "Launch Emacs";
                "Type" = "SIMPLE_ACTION_DATA";
              };
              "Data_1_1Actions" = {
                "ActionsCount" = "1";
              };
              "Data_1_1Actions0" = {
                "CommandURL" = "systemd-run --user emacsclient -c";
                "Type" = "COMMAND_URL";
              };
              "Data_1_1Triggers" = {
                "Comment" = "Simple_action";
                "TriggersCount" = "1";
              };
              "Data_1_1Triggers0" = {
                "Key" = "Meta+E";
                "Type" = "SHORTCUT";
                "Uuid" = "{d03619b6-9b3c-48cc-9d18-7fcbb5c16662}";
              };
            };
            "kwinrc" = {
              Plugins = {
                krohnkite = true;
              };
              Krohnkite = {
                innerGaps = 8;
                outerGapsTop = 10;
                outerGapsBottom = 10;
                outerGapsLeft = 8;
                outerGapsRight = 8;
                layout = "Stairs";
                borderWidth = 2;
                showFloatingIndicator = true;
              };
            };
          };
        }; 
        services.emacs = {
          enable = true;
          #package = config.programs.doom-emacs.finalPackage;
          client.enable = true;
          socketActivation.enable = true;
        };
        programs.git.enable = true;
        home.packages = with pkgs; [
          grim
          slurp
          kanshi
          cage
          clipman
          waypipe
          wdisplays
          #wdomirror
          wlr-randr
          xdg-desktop-portal-wlr
          qt5.qtwayland
        ];
      };
    };
  };
}
