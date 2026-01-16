{ self, config, lib, inputs, ... }:
{
  flake = {
    homeModules = {
      # Cross-platform shared configuration
      common = {
        home.stateVersion = "22.11";
        imports = [
          ./terminal.nix
          ./git.nix
          ./direnv.nix
          ./kitty.nix
        ];
        programs.git.enable = true;
      };

      # Linux/NixOS-specific home configuration
      linux = { pkgs, config, ... }: {
        imports = [
          self.homeModules.common
          inputs.nix-doom-emacs-unstraightened.hmModule
          inputs.plasma-manager.homeModules.plasma-manager
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
                "KrohnkiteSetMaster" = "Meta+Shift+Return,none,Krohnkite: Set master";
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
          client.enable = true;
          socketActivation.enable = true;
        };
        home.packages = with pkgs; [
          grim
          slurp
          kanshi
          cage
          clipman
          waypipe
          wdisplays
          wlr-randr
          xdg-desktop-portal-wlr
          qt5.qtwayland
        ];
      };

      # macOS/Darwin-specific home configuration
      darwin = { pkgs, config, lib, ... }: {
        imports = [
          self.homeModules.common
          inputs.nix-doom-emacs-unstraightened.hmModule
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
        services.emacs = {
          enable = true;
          client.enable = true;
          defaultEditor = true;
        };

        # Shell alias for GUI emacsclient
        programs.zsh.shellAliases = {
          ec = "emacsclient -c -n";
          et = "TERM=xterm-256color emacsclient -t";
        };

        # Create Emacsclient.app with proper bundle structure
        home.activation.createEmacsClientApp = lib.hm.dag.entryAfter ["writeBoundary"] ''
          APP="$HOME/Applications/Emacsclient.app"
          rm -rf "$APP"
          mkdir -p "$APP/Contents/MacOS"
          mkdir -p "$APP/Contents/Resources"

          # PkgInfo
          echo -n "APPL????" > "$APP/Contents/PkgInfo"

          # Info.plist
          cat > "$APP/Contents/Info.plist" << 'PLIST'
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>CFBundleName</key>
            <string>Emacsclient</string>
            <key>CFBundleDisplayName</key>
            <string>Emacsclient</string>
            <key>CFBundleIdentifier</key>
            <string>org.gnu.emacsclient</string>
            <key>CFBundleVersion</key>
            <string>1.0</string>
            <key>CFBundlePackageType</key>
            <string>APPL</string>
            <key>CFBundleSignature</key>
            <string>????</string>
            <key>CFBundleExecutable</key>
            <string>emacsclient-wrapper</string>
            <key>LSMinimumSystemVersion</key>
            <string>10.10</string>
            <key>LSUIElement</key>
            <false/>
            <key>NSHighResolutionCapable</key>
            <true/>
          </dict>
          </plist>
          PLIST

          # Executable
          cat > "$APP/Contents/MacOS/emacsclient-wrapper" << SCRIPT
          #!/bin/bash
          export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:\$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:\$PATH"
          exec emacsclient -c -n -a "" "\$@"
          SCRIPT
          chmod +x "$APP/Contents/MacOS/emacsclient-wrapper"

          # Remove quarantine and ad-hoc sign the app
          /usr/bin/xattr -cr "$APP" 2>/dev/null || true
          /usr/bin/codesign --force --deep --sign - "$APP" 2>/dev/null || true
        '';
      };

      # Default is Linux for backwards compatibility
      default = self.homeModules.linux;
    };
  };
}
