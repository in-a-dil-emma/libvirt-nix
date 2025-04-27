{ config, ... }: {
  config.systemd.user.services."libvirt-nix" = {
    Unit = {
      Wants = [
        "basic.target"
      ];
      After = [
        "basic.target"
      ];
    };
    Install.WantedBy = [
      "default.target"
    ];
    Service.ExecStart = config.libvirt-nix.mainScript.outPath;
  };
}
