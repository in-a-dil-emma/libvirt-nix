{
  definition,
  unmanaged,

  submodule,
  mkOption,
  attrsOf,

  flip,
  pipe,
  ...
}:
flip pipe [ submodule attrsOf ] {
  options = {
    networks = mkOption {
      type = definition;
      default = null;
    };
    domains = mkOption {
      type = definition;
      default = null;
    };
    pools = mkOption {
      type = definition;
      default = null;
    };
    unmanaged = mkOption {
      type = unmanaged;
      default = { };
    };
  };
}
