let
  inputs = import ./npins;
  pkgs = import inputs.nixpkgs {};
  inherit (pkgs) mkShellNoCC npins;
in mkShellNoCC {
  packages = [
    npins
  ];
  NIX_PATH="nixpkgs=${pkgs.path}";
}
