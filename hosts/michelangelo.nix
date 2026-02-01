{ config, lib, pkgs, ... }: {
  imports = [
    ../users/ddd.nix
    ../common
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/apple-silicon-support
  ];
  config = {

    networking.hostName = "michelangelo";

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;
    networking.networkmanager.enable = true; # nmcli
    environment.systemPackages = with pkgs; [ vim wget gh git neovim ];
    system.stateVersion = "25.11"; # Did you read the comment?
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
