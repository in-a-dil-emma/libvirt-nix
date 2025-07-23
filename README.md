# NixOS module for configuring Libvirt domains, pools and networks

> [!CAUTION]
> This module is still not production ready[^1].

[^1]: The URLs below will get updated to point to the release tags.

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

### Import

#### NixOS

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

#### Home Manager

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
<summary>virtualisation.<b>libvirtd</b></summary>

| OPTION       | TYPE      | DESCRIPTION         |
|--------------|-----------|---------------------|
| connections  | submodule | Paths to connect to |

</details>

<details>
<summary>virtualisation.libvirtd.connections.<b><ins>uri</ins></b></summary>

| OPTION   | DEFAULT | TYPE              |
|----------|---------|-------------------|
| networks | null    | submodule or null |
| domains  | null    | submodule or null |
| pools    | null    | submodule or null |

</details>

### Managed libvirt entities

<details>
<summary>virtualisation.libvirtd.connections.<ins>uri</ins>.<ins>type</ins>.<b><ins>list element</ins></b></summary>

| OPTION     | TYPE            | DESCRIPTION                                          |
|------------|-----------------|------------------------------------------------------|
| active     | null or boolean | null ⇒ do nothing                                    |
| restart    | null or boolean | false ⇒ do nothing, null ⇒ only on definition change |
| definition | path or string  | path to file or string literal                       |

</details>

<details>

<summary>virtualisation.libvirtd.connections.<ins>uri</ins>.<b>unmanaged</b></summary>

| OPTION   | DEFAULT | TYPE              | DESCRIPTION                   |
|----------|---------|-------------------|-------------------------------|
| networks | null    | submodule or null |                               |
| domains  | null    | submodule or null |                               |
| pools    | null    | submodule or null |                               |
| mutable  | false   | boolean           | true ⇒ ignore unknown objects |

</details>

### Unmanaged libvirt entities

<details>
<summary>virtualisation.libvirtd.connections.<ins>uri</ins>.unmanaged.<ins>type</ins>.<b><ins>list element</ins></b></summary>

| OPTION  | TYPE             | DESCRIPTION        |
|---------|------------------|--------------------|
| active  | null or boolean  | null ⇒ do nothing  |
| restart | boolean          | false ⇒ do nothing |
| name    | string or RegExp | must be unique     |

</details>

## Example

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
        # the setup script will apply configuration to each entity one by one in a loop
        # said loop, when described using pseudo-code, will look roughly like this:
        #   if { ∉ declared } then { stop; undefine; next entity; }
        #   if { ∈ unmanaged && name ∉ names in unmanaged } then { stop; undefine; next entity; }
        #   if { ∈ managed } then { apply definition; }
        #   if { !running && active == true } then { start; }
        #   else if { running && active == false } then { stop; }
        #   else { do nothing; }
        #   if { running && restart == null && definition changed } then { restart; }
        #   else if { running && restart == true } then { restart; }
        #   else { do nothing; }
        networks = [
          {
            active = true;   # start this network
            restart = false; # do not restart this network, even if the definition changed
            definition = ./virsh/system-default-net.xml;
          }
          {
            active = null;  # don't start nor stop this network
            restart = true; # however, do restart it, if it happens to be running
            definition = ./virsh/system-special-net.xml;
          }
          {
            active = false; # stop this network
            restart = null; # in this case this is a no-op, but if "active" were to be true or null, it would restart the network (if it were running) and if the definition changed
            definition = ./virsh/system-isol-net.xml;
          }
        ];
        # nuke all pools
        pools = [ ];
        # "domains = null;" is implied by the default value of "null" for this option, which means: do nothing
      };
    };
  };
}
```