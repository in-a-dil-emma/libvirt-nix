{ submodule
, mkOption
, listOf
, nullOr
, bool
, str

, flip
, pipe
, ... }:
flip pipe [ submodule listOf nullOr ] {
  options = {
    active = mkOption { type = nullOr bool; };
    restart = mkOption { type = bool; };
    name = mkOption { type = str; };
  };
}