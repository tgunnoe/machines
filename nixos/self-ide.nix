{ pkgs, people, ... }: {
  # For no-prompt Ctrl+Shift+B in VSCode
  security.sudo.extraRules = [
    {
      users = [ people.myself ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
