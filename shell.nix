let
  inputs = import ./npins;
  pkgs = import inputs.nixpkgs {};
  treefmt = import inputs.treefmt-nix;

  inherit (pkgs)
    mkShellNoCC
    npins
    ;
in mkShellNoCC {
  packages = [
    (treefmt.mkWrapper pkgs ./lib/treefmt.nix)
    npins
  ];
  NIX_PATH="nixpkgs=${pkgs.path}";
}
