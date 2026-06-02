{
  submodule,
  mkOption,
  listOf,
  nullOr,
  oneOf,
  bool,
  path,
  enum,
  str,

  flip,
  pipe,
  ...
}:
flip pipe [ submodule listOf nullOr ] {
  options = {
    active = mkOption { type = enum [ true false null "once" "inactive" ]; };
    restart = mkOption { type = nullOr bool; };
    definition = mkOption { type = oneOf path str; };
  };
}