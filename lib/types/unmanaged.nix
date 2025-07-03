{
  unmanaged-definition,

  submodule,
  mkOption,
  attrsOf,

  flip,
  pipe,
  ...
}:
flip pipe [ attrsOf submodule ] {
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
  };
}
