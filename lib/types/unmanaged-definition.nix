{
  submodule,
  mkOption,
  listOf,
  nullOr,
  bool,
  enum,
  str,

  flip,
  pipe,
  ...
}:
flip pipe [ submodule listOf nullOr ] {
  options = {
    active = mkOption { type = enum [ true false null "once" ]; };
    restart = mkOption { type = bool; };
    name = mkOption { type = str; };
  };
}