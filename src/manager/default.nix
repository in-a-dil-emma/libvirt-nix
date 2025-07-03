{
  pkgs ? import (import ../../npins).nixpkgs { },
  ...
}:
let
  inherit (pkgs.python3Packages)
    buildPythonApplication
    setuptools
    libvirt
    ;
in
buildPythonApplication {
  name = "libvirt-nix-setup-script";
  pyproject = true;
  build-system = [
    setuptools
  ];
  propagatedBuildInputs = [
    libvirt
  ];
  src = ./.;
}
