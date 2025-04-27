{ definition

, submodule
, mkOption
, attrsOf

, flip
, pipe
, ... }:
flip pipe [ attrsOf submodule ] ({ config, name, ... }: {
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
  };
})
