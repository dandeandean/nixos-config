{ config, lib, pkgs, ... }: {
  imports = [
    ../users/ddd.nix
    ../common
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/apple-silicon-support
  ];
  config = {
    hardware = {
      apple.touchBar = { enable = true; };
      graphics = { enable = true; };
    };
    bloat.enable = true;
  };
}
