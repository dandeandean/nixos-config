{ config, lib, pkgs, ... }: {
  imports = [
    ../users/ddd.nix
    ../common/packages.nix
    ../common/k3s.nix
    ../common/home-manager.nix
    ../common/system.nix

    /etc/nixos/hardware-configuration.nix
    /etc/nixos/apple-silicon-support
  ];
  hardware = {
    apple.touchBar = { enable = true; };
    graphics = { enable = true; };
  };
  k3s.isK3sNode.enable = true;
}
