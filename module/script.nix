{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) writeShellScript;
  inherit (lib.types) package;
  inherit (lib) mkOption;
in
{
  options.libvirt-nix = {
    mainScript = mkOption {
      internal = true;
      visible = false;
      type = package;
    };
  };

  config.libvirt-nix.mainScript = writeShellScript "configure-libvirt-main" ''
    exec ${lib.getExe pkgs.hello}
  '';
}
