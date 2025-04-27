{ config, pkgs, lib, ... }: let
  inherit (lib) mapAttrsToList mkOption concatStringsSep;
  inherit (lib.types) attrsOf package str;
  inherit (pkgs) writeShellScript;
in {
  options.libvirt-nix = {
    mainScript = mkOption {
      internal = true;
      visible = false;
      type = package;
    };
    configureScripts = mkOption {
      internal = true;
      visible = false;
      type = attrsOf str;
      apply = mapAttrsToList writeShellScript;
    };
  };

  config.libvirt-nix.mainScript = writeShellScript "configure-libvirt-main" ''
    for i in ${concatStringsSep " " config.libvirt-nix.configureScripts}; do
        [ -e "$i" ] && ("$i" || echo "$i failed")
    done
  '';
}
