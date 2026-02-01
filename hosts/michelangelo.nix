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
    # The following is needed for swaylock to work
    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };
}
