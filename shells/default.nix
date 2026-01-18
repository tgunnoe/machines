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
        inputs'.colmena.packages.colmena

        # age password encryption
        inputs'.ragenix.packages.default
        pkgs.age # age command line tool
      ];
      shellHook = ''
        echo "NixOS machines deployment shell for ${system}."
        echo "Available commands:"
        echo "  colmena apply              - Deploy to all machines"
        echo "  colmena apply --on <host>  - Deploy to specific host"
        echo "  colmena build              - Build configurations"
        echo "  colmena eval               - Evaluate configurations"
      '';
    };
  };
}
