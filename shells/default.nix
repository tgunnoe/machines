{
  inputs,
  pkgs,
  ...
}: {
  perSystem = {
    inputs',
    pkgs,
    system,
    ...
  }: {
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShell {
      buildInputs = [
        # deployment
        #inputs'.colmena.packages.colmena

        # age password encryption
        inputs'.ragenix.packages.default
        pkgs.age # age command line tool
      ];
      shellHook = ''
        echo "Sidechains CI deployment for ${system}."
      '';
    };
  };
}
