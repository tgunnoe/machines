{ config, pkgs, lib, flake, ... }:

{
  # Let me login
  users.users =
    let
      people = flake.config.people;
      myKeys = people.users.${people.myself}.sshKeys;
      password = people.users.${people.myself}.hashedPassword;
    in
    {
      root.openssh.authorizedKeys.keys = myKeys;
      ${people.myself} = {
        hashedPassword = password;
        openssh.authorizedKeys.keys = myKeys;
      };
    };
}
