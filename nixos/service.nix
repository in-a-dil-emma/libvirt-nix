{ config, ... }:
{
  config.systemd.services."libvirt-nix" = {
    description = "Configure libvirtd";
    after = [ "libvirtd.service" ];
    before = [ "libvirt-guests.service" ];
    requires = [ "libvirtd.service" ];
    requiredBy = [ "libvirt-guests.service" ];
    wantedBy = [ "multi-user.target" ];
    script = config.libvirt-nix.mainScript.outPath;
  };
}