{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) writeShellScript;
  inherit (lib) mkOption getExe';
  inherit (lib.types) package;
  inherit (builtins) toJSON;

  script = import ../src/manager pkgs;
  dataJSON = toJSON config.virtualisation.libvirtd.connections;
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
    exec ${getExe' script "main.py"} '${dataJSON}'
  '';
}
