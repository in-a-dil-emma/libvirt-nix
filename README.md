# NixOS module for configuring Libvirt domains, pools and networks

## Setup

### Inputs

<details>
<summary>
Flakes
</summary>

```nix
{
  inputs = {
    libvirt-nix.url = "github:in-a-dil-emma/libvirt-nix/dev";
  };
}
```

</details>

<details>
<summary>
npins
</summary>

```console
$ npins add github in-a-dil-emma libvirt-nix -b dev
```

</details>

### Import in NixOS

<details>
<summary>
Flakes
</summary>

```nix
{ libvirt-nix, ... }: {
  imports = [
    libvirt-nix.nixosModule
  ];
}
```

</details>

<details>
<summary>
npins
</summary>

```nix
{ libvirt-nix, ... }: {
  imports = [
    (libvirt-nix + "/nixos")
  ];
}
```

</details>

### Import in Home Manager (standalone or as a NixOS module)

<details>
<summary>
Flakes
</summary>

```nix
{ libvirt-nix, ... }: {
  imports = [
    libvirt-nix.homeModule
  ];
}
```

</details>

<details>
<summary>
npins
</summary>

```nix
{ libvirt-nix, ... }: {
  imports = [
    (libvirt-nix + "/home-manager")
  ];
}
```

</details>

## Configuring

<details>
<summary>virtualisation → <b>libvirtd</b></summary>

| OPTION       | DEFAULT             | TYPE      | DESCRIPTION         |
|--------------|---------------------|-----------|---------------------|
| connections  | unset               | submodule | Paths to connect to |

</details>

<details>
<summary>... → connections → <b><ins>uri</ins></b></summary>

| OPTION   | DEFAULT | TYPE              | DESCRIPTION             |
|----------|---------|-------------------|-------------------------|
| networks | null    | submodule or null | Networks to define      |
| domains  | null    | submodule or null | Domains to define       |
| pools    | null    | submodule or null | Storage pools to define |

</details>

<details>
<summary>... → <b><ins>list element</ins></b></summary>

| OPTION     | TYPE           | DESCRIPTION                            |
|------------|----------------|----------------------------------------|
| enable     | bool or null   | null ⇒ ignore                          |
| restart    | bool or null   | null ⇒ on definition change, if active |
| definition | path or string | Path to .xml file                      |

</details>

<details>
<summary><i>Examples</i></summary>

```nix
{ pkgs, ... }: {
  virtualisation.libvirt-nix = {
    enable = true;
    package = pkgs.libvirt-glib;
    connections = {
      "qemu:///system" = {
        # the options are identical for networks, pools and domains
        networks = [
          # enable == true + restart == false ⇒ define this net, but never restart it
          {
            enable = true;
            restart = false;
            definition = ./virsh/system-default-net.xml;
          }
          # enable == null + restart == null ⇒ restart net only if already running
          {
            enable = null;
            restart = null;
            definition = ./virsh/system-special-net.xml;
          }
        ];
        # nuke all pools
        pools = [ ];
        # "domains = null;" is implied by the default value ⇒ do nothing
      };
    };
  };
}
```

</details>
