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
    # https://github.com/SwayKh/dotfiles/blob/main/waybar/style.css
    programs.waybar = {
      enable = true;
      style = ''
      /* Use Pywal16 colors  */
      @define-color fg alpha(@background, 1.0);
      @define-color bg alpha(@foreground, 1.0);
      @define-color bordercolor alpha(@background, 1.0);
      @define-color alert #F14241;
      @define-color disabled #A5A5A5;
      @define-color highlight #D49621;
      @define-color activegreen #26A65B;

      * {
	min-height: 0;
	font-family: "JetBrainsMono Nerd Font", Roboto, Helvetica, Arial, sans-serif;
	font-size: 1rem; /* Adjust font using gtk-font size, like nwg-look or lxappearance */
      }

      window#waybar {
	color: @fg;
	background-color: @bg;
	background: none;
      }
      #window,
      #workspaces {
	color: @bordercolor;
	background-color: @bg;
	border: 0.1rem solid @bordercolor;
	border-radius: 0.5rem;
	padding: 0.1rem 0.5rem;
	margin: 0.1rem;
      }
      #workspaces button {
	color: @bordercolor;
	background-color: @bg;
	border: 0rem solid @bordercolor;
	padding: 0.1rem;
	margin: 0.1rem;
      }

      #clock,
      #cava,
      #battery,
      #bluetooth,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #language,
      #backlight,
      #backlight-slider,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #taskbar,
      #tray,
      #tray menu,
      #tray > .needs-attention,
      #tray > .passive,
      #tray > .active,
      #mode,
      #scratchpad,
      #custom-notification,
      #custom-temp,
      #custom-wifi,
      #custom-kdeconnect,
      #custom-bluetooth,
      #custom-power,
      #custom-separator,
      #custom-group,
      #idle_inhibitor,
      #window,
      #mpd {
	color: @bordercolor;
	background-color: @bg;
	border: 0.1rem solid @bordercolor;
	border-radius: 0.5rem;
	padding: 0.1rem 0.5rem;
	margin: 0.1rem;
      }

      #bluetooth {
	color: @bordercolor;
	background-color: @color1;
      }
      #battery,
      #network {
	color: @bordercolor;
	background-color: @color2;
      }
      #cpu {
	color: @bordercolor;
	background-color: @color3;
      }
      #memory {
	color: @bordercolor;
	background-color: @color4;
      }
      #temperature {
	color: @bordercolor;
	background-color: @color5;
      }
      #custom-notification,
      #backlight {
	color: @bordercolor;
	background-color: @color6;
      }
      #pulseaudio,
      #wireplumber {
	color: @bordercolor;
	background-color: @color3;
      }
      #clock {
	color: @bordercolor;
	background-color: @color9;
      }

      #workspaces,
      #workspaces button {
	color: @bordercolor;
	background-color: @color4;
      }
      #tray,
      #tray menu,
      #tray > .needs-attention,
      #tray > .passive,
      #tray > .active,
      #custom-wifi,
      #custom-kdeconnect,
      #custom-bluetooth,
      #custom-power,
      #custom-group,
      #idle_inhibitor {
	color: @bordercolor;
	background-color: @color5;
	border: 0rem solid @bordercolor;
      }
      #window {
	color: @bordercolor;
	background-color: @color6;
      }

      #custom-group {
	border: 0.1rem solid @bordercolor;
      }

      #custom-separator {
	color: @disabled;
      }

      #network.disconnected,
      #pulseaudio.muted,
      #wireplumber.muted {
	background-color: @alert;
      }

      #battery.charging,
      #battery.plugged {
	background-color: @activegreen;
      }

      label:focus {
	background-color: @bg;
      }
      '';
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

