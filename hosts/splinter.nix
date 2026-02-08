{ config, lib, pkgs, ... }: {
  imports =
    [ /etc/nixos/hardware-configuration.nix ../users/ddd.nix ../common ];

  config = {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    networking.hostName = "splinter";

    # custom options
    sshBox.enable = true;
    sshBox.doSecurity = false;
    isK3sNode.enable = true;

    tailscale.enable = true;

    # Don't change unless you like pain
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
