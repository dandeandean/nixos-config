# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  do_security = false;
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

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      ports = [ 22 ];
    };
    services.fail2ban.enable = do_security;
    networking.firewall.enable = do_security;

    # Don't change unless you like pain
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}

