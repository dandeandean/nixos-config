# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  do_security = false;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ddd = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      gh
      tmux
      jq
    ];
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
     # System
     wget
     kubernetes
     kubectl
     kompose
     python3
     htop
     nmap

     # Editing
     vim
     git
     neovim
     ripgrep
     zk
     luarocks
     lua
     rustc
     cargo
     go
     nodejs_22
     gcc_multi
     unzip

     # Desktop Env

     wofi
     waybar
     hyprpaper
     ghostty
     firefox
   ];


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


  /*
  TODO: Make this a module
  ########################################
  ############# K8s Settings #############
  ########################################

  # No need for docker b/c containerd gets spawned
  # Have this computer pinned to 10.0.0.10 in the network
  networking.extraHosts = "10.0.0.10 api.kube";
  networking.enableIPv6 = false;
  # With IPv6 enabled, the nameservers look like this
  # networking.nameservers = [
  #   "75.75.75.75"
  #   "75.75.76.76"
  #   "2001:558:feed::1"
  #   "2001:558:feed::2
  # ];
  # We only want 3 of these or else k8s will yell at us, so we'll just disable IPv6

  # Disable swap
  swapDevices = lib.mkForce [ ];

  services.kubernetes = {
    # As per nlewo.github.io
    # Master enables apiserver, controllerManager, scheduler, addonManager, kube-proxy, & etcd
    # Node enables kube-proxy
    roles = [ "master" "node" ];
    masterAddress = "api.kube";
    apiserverAddress = "https://api.kube:6443";
    # This may require changing permissions on the cluster-admin-key
    # sudo chmod go+r /var/lib/kubernetes/secrets/cluster-admin-key.pem
    easyCerts = true;
    apiserver = {
      securePort = 6443;
      advertiseAddress = "10.0.0.10";
    };
    addons.dns.enable = true; 
  };
  */
  ########################################
  ############# GUI Settings #############
  ########################################

  # Login stuff
  services.displayManager = {
    enable = true;
    sddm.enable = true;
    sddm.wayland.enable = true;
  };

  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.waybar.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix).
  system.copySystemConfiguration = true;

  # Don't change unless you like pain
  system.stateVersion = "25.05"; # Did you read the comment?
}

