# NixOS Config
For me & myself

## The System Config

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
  - $HOME/git/desktop-env
