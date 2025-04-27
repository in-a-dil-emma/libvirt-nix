{ lib
, ...
}:

let
  xtypes = import ../lib/types lib;

  inherit (xtypes) connection;
  inherit (lib) mkOption;
in {
  options.virtualisation.libvirtd = {
    connections = mkOption {
      type = connection;
    };
  };
}
