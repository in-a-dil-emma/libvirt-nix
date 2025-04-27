lib: let
  xlib = lib // lib.types // builtins // xtypes;
  xtypes = {
    connection = import ./connection.nix xlib;
    definition = import ./definition.nix xlib;
  };
in xtypes
