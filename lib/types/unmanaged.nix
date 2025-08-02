{
  unmanaged-definition,

  submodule,
  mkOption,
  attrsOf,
  bool,

  flip,
  pipe,
  ...
}:
flip pipe [ submodule attrsOf ] {
  options = {
    networks = mkOption {
      type = unmanaged-definition;
      default = null;
    };
    domains = mkOption {
      type = unmanaged-definition;
      default = null;
    };
    pools = mkOption {
      type = unmanaged-definition;
      default = null;
    };
    mutable = mkOption {
      type = bool;
      default = false;
    };
  };
}
