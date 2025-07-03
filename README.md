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

| OPTION       | TYPE      | DESCRIPTION         |
|--------------|-----------|---------------------|
| connections  | submodule | Paths to connect to |

</details>

<details>
<summary>virtualisation → libvirtd → connections → <b><ins>uri</ins></b></summary>

| OPTION   | DEFAULT | TYPE              |
|----------|---------|-------------------|
| networks | null    | submodule or null |
| domains  | null    | submodule or null |
| pools    | null    | submodule or null |

</details>

<details>
<summary>virtualisation → libvirtd → connections → <ins>uri</ins> → <ins>type</ins> → <b><ins>list element</ins></b></summary>

| OPTION     | TYPE            | DESCRIPTION                                          |
|------------|-----------------|------------------------------------------------------|
| active     | null or boolean | null ⇒ do nothing                                    |
| restart    | null or boolean | false ⇒ do nothing, null ⇒ only on definition change |
| definition | path or string  | Path to .xml file                                    |

</details>

<details>
<details>
<summary>virtualisation → libvirtd → connections → <ins>uri</ins> → <b>unmanaged</b></summary>

| OPTION   | DEFAULT | TYPE              |
|----------|---------|-------------------|
| networks | null    | submodule or null |
| domains  | null    | submodule or null |
| pools    | null    | submodule or null |

</details>

### Unmanaged libvirt domains

<details>
<summary>virtualisation → libvirtd → connections → <ins>uri</ins> → unmanaged → <ins>type</ins> → <b><ins>list element</ins></b></summary>

| OPTION  | TYPE            | DESCRIPTION        |
|---------|-----------------|--------------------|
| active  | null or boolean | null ⇒ do nothing  |
| restart | boolean         | false ⇒ do nothing |
| name    | string          | must be unique     |

</details>

<details>
<summary><i>Examples</i></summary>

```nix
{ pkgs, ... }: {
  virtualisation.libvirtd = {
    # Provided by NixOS
    enable = true;
    package = pkgs.libvirt-glib;
    # Provided by this module
    connections = {
      "qemu:///system" = {
        # the options are identical for networks, pools and domains
        # the setup script will apply configuration to each entity one by one:
        #   if the entity is no longer declared, destroy and undefine it
        #   apply false active state or shut down to restart
        #   apply (new) definition
        #   apply true active state or start from restart
        networks = [
          {
            active = true;   # start this network, will also affect autostart
            restart = false; # do not restart this network, even if the definition changed
            definition = ./virsh/system-default-net.xml;
          }
          {
            active = null; # don't start nor stop this network
            restart = true;    # however do restart it if it happens to be running
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