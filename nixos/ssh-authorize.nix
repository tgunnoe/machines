{ config, pkgs, lib, people, ... }:

{
  # Let me login
  users.users =
    let
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
