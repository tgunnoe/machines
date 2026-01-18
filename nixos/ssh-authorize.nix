{ config, pkgs, lib, flake, ... }:

{
  # Let me login
  users.users =
    let
      myKeys = flake.people.users.${flake.people.myself}.sshKeys;
      password = flake.people.users.${flake.people.myself}.hashedPassword;
    in
    {
      root.openssh.authorizedKeys.keys = myKeys;
      ${flake.people.myself} = {
        hashedPassword = password;
        openssh.authorizedKeys.keys = myKeys;
      };
    };
}
