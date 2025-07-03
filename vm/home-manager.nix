{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."user" = { lib, ... }: {
      imports = [
        ../home-manager
      ];

      virtualisation.libvirtd.connections."qemu:///session" = {};

      home.file.".zshrc".text = "";

      home.stateVersion = lib.trivial.release;
    };
  };
}
