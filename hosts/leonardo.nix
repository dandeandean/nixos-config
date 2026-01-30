{ config, lib, pkgs, ... }: {
  imports = [
    ../users/ddd.nix
    ../common
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/apple-silicon-support
  ];
  config = {
    networking.hostName = "leonardo";
    bloat.enable = false;
    isK3sNode.enable = true;
    isK3sNode.isServer = false;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;
    system.stateVersion = "25.11"; # Don't change
  };
}
