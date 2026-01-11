{ config, lib, pkgs, ... }: {
  imports = [
    ../users/ddd.nix
    ../common/packages.nix
    ../common/k3s.nix
    ../common/home-manager.nix

    /etc/nixos/hardware-configuration.nix
    /etc/nixos/apple-silicon-support
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.copySystemConfiguration = true;
  hardware = {
    apple.touchBar = { enable = true; };
    graphics = { enable = true; };
  };
}
