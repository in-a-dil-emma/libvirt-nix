{ submodule
, mkOption
, listOf
, nullOr
, oneOf
, bool
, path
, str

, flip
, pipe
, ... }:
flip pipe [ submodule listOf nullOr ] {
  options = {
    active = mkOption { type = nullOr bool; };
    restart = mkOption { type = nullOr bool; };
    definition = mkOption { type = oneOf path str; };
  };
}