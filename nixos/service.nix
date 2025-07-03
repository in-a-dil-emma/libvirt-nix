{ config, ... }: {
  config.systemd.services."libvirt-nix" = {
    description = "Configure libvirtd";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    script = config.libvirt-nix.mainScript.outPath;
  };
}