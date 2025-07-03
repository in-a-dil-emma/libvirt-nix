{ lib, ... }: {
  virtualisation = {
    graphics = false;
    cores = 4;
    memorySize = 1024 * 2;
    diskSize = 1024 * 2;
    qemu = {
      consoles = [ "tty0" "hvc0" ];
      options = [
        "-serial null"
        "-device virtio-serial"
        "-chardev stdio,mux=on,id=char0,signal=off"
        "-mon chardev=char0,mode=readline"
        "-device virtconsole,chardev=char0,nr=0"
      ];
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    connections."qemu:///system" = {};
  };

  environment.loginShellInit = ''
    trap 'sudo poweroff' EXIT
  '';

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  networking.networkmanager.enable = true;

  services.getty.autologinUser = "user";
  users.users."user" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "password";
  };

  boot.tmp.useTmpfs = true;

  system.stateVersion = lib.trivial.release;
}
