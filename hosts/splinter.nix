{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  desktop_env = false;
in {
  imports =
    [ /etc/nixos/hardware-configuration.nix ../users/ddd.nix ../common ];

  config = {
    # Use the systemd-boot EFI boot loader.
    isK3sNode.enable = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    networking.hostName = "splinter";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "ter-i32b";
      packages = [ pkgs.terminus_font ];
    };

    # List services that you want to enable:

    ########################################
    ############# SSH Settings #############
    ########################################
    options.sshBox.enable = true;

    # Enable the OpenSSH daemon.

    # Don't change unless you like pain
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}

