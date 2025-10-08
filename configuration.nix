# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  do_security = false;
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
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
  };

  home-manager.backupFileExtension = "bkp";

  # Need this or else no restart
  programs.zsh.enable = true;

  # Desktop stuff

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

  home-manager.users.ddd = { pkgs, ... }: {
    home.stateVersion = "25.05"; # Static
    imports = [
      /home/ddd/.config/home-manager/home.nix
    ];

    ## NixOS specific
    programs.waybar = {
      enable = true;
    };
    services.hyprpaper = {
      enable = true;
      settings = {
	preload = [
	  "/home/ddd/git/nixos-config/wallpaper.jpg"
	];
	wallpaper = [
	  ", /home/ddd/git/nixos-config/wallpaper.jpg"
	];
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
	"$terminal" = "ghostty";
	"$fileManager" = "dolphin";
	"$menu" = "wofi --show drun";
	general = {
	  "$mainMod" = "SUPER";
	};
	# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
	bind = [
	  "$mainMod, Q, exec, $terminal"
	  "$mainMod, C, killactive,"
	  "$mainMod, M, exit,"
	  "$mainMod, E, exec, $fileManager"
	  "$mainMod, V, togglefloating,"
	  "$mainMod, space, exec, $menu"
	  "$mainMod, P, pseudo, # dwindle"
	  "$mainMod, J, togglesplit, # dwindle"

	  "$mainMod, 1, workspace, 1"
	  "$mainMod, 2, workspace, 2"
	  "$mainMod, 3, workspace, 3"
	  "$mainMod, 4, workspace, 4"
	  "$mainMod, 5, workspace, 5"
	  "$mainMod, 6, workspace, 6"
	  "$mainMod, 7, workspace, 7"
	  "$mainMod, 8, workspace, 8"
	  "$mainMod, 9, workspace, 9"
	  "$mainMod, 0, workspace, 10"
	  "$mainMod SHIFT, 1, movetoworkspace, 1"
	  "$mainMod SHIFT, 2, movetoworkspace, 2"
	  "$mainMod SHIFT, 3, movetoworkspace, 3"
	  "$mainMod SHIFT, 4, movetoworkspace, 4"
	  "$mainMod SHIFT, 5, movetoworkspace, 5"
	  "$mainMod SHIFT, 6, movetoworkspace, 6"
	  "$mainMod SHIFT, 7, movetoworkspace, 7"
	  "$mainMod SHIFT, 8, movetoworkspace, 8"
	  "$mainMod SHIFT, 9, movetoworkspace, 9"
	  "$mainMod SHIFT, 0, movetoworkspace, 10"
	  "$mainMod, S, togglespecialworkspace, magic"
	  "$mainMod SHIFT, S, movetoworkspace, special:magic"
	  "$mainMod, mouse_down, workspace, e+1"
	  "$mainMod, mouse_up, workspace, e-1"
	];
	exec-once = [
	  "waybar"
	  "hyprpaper"
	  "ghostty"
	];
      };
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix).
  system.copySystemConfiguration = true;

  # Don't change unless you like pain
  system.stateVersion = "25.05"; # Did you read the comment?
}

