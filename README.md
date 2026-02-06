# NixOS Config

This comprises of 5 hosts.
Splinter, Leonardo, & Raphael are joined in a k3s cluster.
Michaelangelo & Leonardo are Asahi Linux machines. 

## The System Configuration
Each host has an entry in the `hosts/` directory.
The system's `/etc/nixos/configuration.nix` should remain simple & import the corresponding file.

Example for `splinter`:
```nix

{ config, lib, pkgs, ... }:
{
  imports =
    [
      /home/ddd/git/nixos-config/hosts/splinter.nix
    ];
}
```

### Todo
Write something that can grab some of the fixtures we need:
I.E.:
  - $HOME/git/dotfiles
  - $HOME/git/desktop-env (for the desktop environment)
  - $HOME/.kube/cluster-secret
