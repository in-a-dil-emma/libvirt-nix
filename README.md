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

| OPTION     | TYPE                                | DESCRIPTION                                                                  |
|------------|-------------------------------------|------------------------------------------------------------------------------|
| active     | null, boolean, "once" or "inactive" | null ⇒ do nothing, "once" ⇒ start then ignore, "inactive" ⇒ stop then ignore |
| restart    | null or boolean                     | false ⇒ do nothing, null ⇒ only on definition change                         |
| definition | path or string                      | path to file or string literal                                               |

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

| OPTION  | TYPE                                | DESCRIPTION                                                                  |
|---------|-------------------------------------|------------------------------------------------------------------------------|
| active  | null, boolean, "once" or "inactive" | null ⇒ do nothing, "once" ⇒ start then ignore, "inactive" ⇒ stop then ignore |
| restart | null or boolean                     | false ⇒ do nothing, null ⇒ only on definition change                         |
| name    | string or RegExp                    | domain name  as per domain xml, must be unique                               |

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
        #   if { entity not part of declared lists } then { stop; undefine(entity); restart loop with next entity; }
        #   if { entity part of managed list } then { apply(definition); }
        #   if { not running(entity) and active == true } then { start(entity); }
        #   else if { not running(entity) and active == "once" && not reached("default.target") } then { start(entity); }
        #   else if { not running(entity) and active == "once" && was not defined(entity) } then { start(entity); }
        #   else if { running(entity) and active == "inactive" && not reached("default.target") } then { stop(entity); }
        #   else if { running(entity) and active == "inactive" && was not defined(entity) } then { stop(entity); }
        #   else if { running(entity) and active == false } then { stop(entity); }
        #   else { do nothing; }
        #   if { running(entity) && restart == null && definition_changed } then { restart(entity); }
        #   else if { running(entity) && restart == true } then { restart(entity); }
        #   else { do nothing; }
        #   restart loop with next entity;
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