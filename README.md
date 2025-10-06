# NixOS Config
For me & myself

## The Config
The Nix config file is found at `/etc/nixos/configuration.nix`
The system can be build with

```sh
nixos-rebuild switch
```

This should be combined with the `dandeandean/dotfiles` repo.

## Home Manager

For some reason it's very mysterious to get home manager working on startup.
That's because we need to import the module at `nixos-rebuild` time.
We have to `nixos-rebuild` for the changes to pick up.

There's gotta be a more idiomatic way of doing all this.


## TO DO
- [ ] Move home manager around
  It doesn't make sense that there should be a `~/.config` entry if we need to `sudo` rebuild.
  This creates a strange posture where a `home-manager` edit can break the system configuration.
  It may make more sense to move it to `/etc/nixos/home.nix`.

- [ ] Waybar
