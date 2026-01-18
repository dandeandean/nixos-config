{ config, lib, pkgs, ... }: {
  imports = [
    ../users/ddd.nix
    ../common/k3s.nix
    ../common/home-manager.nix
    ../common/system.nix

    /etc/nixos/hardware-configuration.nix
    /etc/nixos/apple-silicon-support
  ];
  config = {
    hardware = {
      apple.touchBar = { enable = true; };
      graphics = { enable = true; };
    };
    # isK3sNode.enable = true;
  };
}
