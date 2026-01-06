# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  do_security = false;
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  desktop_env = false;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
      ../users/ddd.nix
      ../common/packages.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "splinter"; # Define your hostname.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-i32b"; #"Lat2-Terminus16";
    packages = [ pkgs.terminus_font ];	#useXkbConfig = true; # use xkb.options in tty.
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

  services.k3s.enable = true;


  ########################################
  ############# GUI Settings #############
  ########################################

  # Login stuff
  services.displayManager = {
    enable = desktop_env;
    sddm.enable = desktop_env;
    sddm.wayland.enable = desktop_env;
  };

  programs.xwayland.enable = desktop_env;
  programs.hyprland = {
    enable = desktop_env;
    xwayland.enable = desktop_env;
  };

  home-manager.backupFileExtension = "bkp";
  home-manager.users.ddd = { pkgs, ... }: {
    home.stateVersion = "25.05";
    imports = [
      /home/ddd/.config/home-manager/home.nix
    ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix).
  system.copySystemConfiguration = true;

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };
  # Don't change unless you like pain
  system.stateVersion = "25.05"; # Did you read the comment?
}

