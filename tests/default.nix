let
  inputs = import ../npins;
  pkgs = import inputs.nixpkgs { };
  lib = import (inputs.nixpkgs + "/lib");

  inherit (lib) makeBinPath;
  inherit (pkgs) writeShellScript libvirt;
  inherit (pkgs.testers) runNixOSTest;

  mkScript =
    text:
    (writeShellScript "test-script" ''
      export PATH="${makeBinPath [ libvirt ]}:$PATH"
      assert_equals() {
        expected="$1"
        shift
        output="$("$@")"
        if ! [ "$output" = "$1" ]; then
          echo "===ASSERTION FAILED!======================================="
          echo "COMMAND \"$@\""
          echo "===EXPECTED================================================"
          echo "$expected"
          echo "===GOT====================================================="
          echo "$output"
          echo "==========================================================="
          exit 1
        fi
      }
      assert_grep() {
        expected="$1"
        shift
        output="$("$@")"
        if ! [ "$(echo "$output" | grep "$expected" | wc -l)" -gt 0 ]; then
          echo "===ASSERTION FAILED!======================================="
          echo "COMMAND \"$@\""
          echo "===FAILED PATTERN=========================================="
          echo "$expected"
          echo "===GOT====================================================="
          echo "$output"
          echo "==========================================================="
          exit 1
        fi
      }
      ${text}
    '').outPath;
in
runNixOSTest {
  name = "NixOS test";

  defaults = {
    imports = [
      (inputs.home-manager + "/nixos")
      ../nixos
    ];
    virtualisation = {
      libvirtd = {
        enable = true;
        connections."qemu:///system" = { };
      };
    };

    users.users = {
      "admin" = {
        isNormalUser = true;
        extraGroups = [ "libvirtd" ];
      };
      "user".isNormalUser = true;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [
        ../home-manager
        (
          { lib, ... }:
          {
            home.stateVersion = lib.trivial.release;
            virtualisation.libvirtd.connections."qemu:///session" = { };
          }
        )
      ];
      users = {
        "admin" = { };
        "user" = { };
      };
    };
  };

  nodes = {
    basic = {
      virtualisation.libvirtd.connections."qemu:///system" = {
        networks = [
          {
            definition = ./system-default-network.xml;
            restart = false;
            active = true;
          }
        ];
      };
    };
  };

  testScript = ''
    basic.start(allow_reboot=True)
    basic.wait_for_unit("libvirtd.service")
    basic.succeed("${mkScript ''
      virsh --connect='qemu:///system' define --file ${./system-default-domain.xml}
    ''}")
    basic.wait_for_unit("multi-user.target")
    basic.succeed("${mkScript ''
      assert_grep "Autostart:.*yes" virsh --connect='qemu:///system' net-info --network default
      assert_grep "Active:.*yes" virsh --connect='qemu:///system' net-info --network default
      virsh --connect='qemu:///system' net-destroy --network default
      assert_grep "Active:.*no" virsh --connect='qemu:///system' net-info --network default
    ''}")
    basic.succeed("su -c ${mkScript ''
      assert_grep "Active:.*no" virsh --connect='qemu:///session' dominfo --domain default
      assert_equals "" virsh --connect='qemu:///system' list --all \| grep default
    ''} - admin")
    basic.succeed("su -c ${mkScript ''
      assert_grep "Active:.*no" virsh --connect='qemu:///session' dominfo --domain default
      virsh --connect='qemu:///session' undefine --domain default
      assert_equals "" virsh --connect='qemu:///session' list --all \| grep default
    ''} - user")
    basic.reboot()
    basic.wait_for_unit("libvirtd.service")
    basic.succeed("${mkScript ''
      assert_grep "Active:.*no" virsh --connect='qemu:///system' net-info --network default
      assert_grep "Autostart:.*yes" virsh --connect='qemu:///system' net-info --network default
    ''}")
    basic.wait_for_unit("multi-user.target")
    basic.succeed("${mkScript ''
      assert_grep "Active:.*yes" virsh --connect='qemu:///system' net-info --network default
      assert_grep "Autostart:.*yes" virsh --connect='qemu:///system' net-info --network default
    ''}")
    basic.shutdown()
  '';
}
