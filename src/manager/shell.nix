let
  inputs = import ../../npins;
  pkgs = import inputs.nixpkgs { };

  inherit (pkgs)
    mkShellNoCC
    python3
    ;
in
mkShellNoCC {
  name = "python-dev-env";
  packages = [
    (python3.withPackages (
      ps: with ps; [
        libvirt
      ]
    ))
  ];
}
