{ config, lib, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in {
  imports = [ (import "${home-manager}/nixos") ];
  options = { bloat.enable = lib.mkEnableOption "Enable Desktop Environment"; };
  config = {
    home-manager = {
      backupFileExtension = "bkp";
      users.ddd = { pkgs, ... }: {
        config = {
          programs.home-manager.enable = true;
          home = {
            stateVersion = "25.05"; # Static here too
            username = "ddd";
            homeDirectory = "/home/ddd";
            # Disable warning about pkgs mismatch
            enableNixpkgsReleaseCheck = false;
            packages = with pkgs;
              [
                ################### User ###################
                fastfetch
                htop
                curl
                nettools
                powershell
                nvimpager
                nmap
                opentofu
                k9s
                jq
                tree
                fzf

                ###################### DEV ######################
                uv
                sqlite
                lazygit
                gnumake

                ################### NVIM DEPS ###################
                ripgrep
                zk
                luarocks
                lua
                rustc
                cargo
                go
                nodejs_22
                unzip

                ## LSPs ### (that Mason can't sort out)
                rust-analyzer
                lua-language-server
              ]
              #################### DEKSTOP ####################
              ++ lib.optionals (config.bloat.enable) [
                nerd-fonts.agave
                wofi
                ghostty
                firefox
                autotiling-rs
                swaylock
              ];
          };
          fonts.fontconfig.enable = true;
          #################### GUI ENV ####################
          programs.waybar = {
            enable = config.bloat.enable;
            settings = {
              mainBar = {
                layer = "top";
                position = "top";
                height = 30;
                output = [ "eDP-1" "HDMI-A-1" ];
                modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
                modules-right =
                  [ "mpd" "custom/mymodule#with-css-id" "temperature" ];
                "sway/workspaces" = {
                  disable-scroll = true;
                  all-outputs = true;
                };
                # modules-center = [ "sway/window" "custom/hello-from-waybar" ];
                # "custom/hello-from-waybar" = {
                #   format = "hello {}";
                #   max-length = 40;
                #   interval = "once";
                #   exec = pkgs.writeShellScript "hello-from-waybar" ''
                #     echo "from within waybar"
                #   '';
                # };
              };
            };
          };
          wayland.windowManager.sway = {
            enable = config.bloat.enable;
            config = {
              menu = "${pkgs.wofi}/bin/wofi --show drun";
              modifier = "Mod4";
              terminal = "ghostty";
              bars = [{ command = "waybar"; }];
            };
            extraConfig = ''
              gaps inner 10
              gaps horizontal 10
              gaps vertical 10
              default_border none
              exec autotiling-rs

              bindgesture swipe:right workspace prev
              bindgesture swipe:left workspace next
              input "type:keyboard" xkb_options caps:escape
            '';
          };

          ###################### GIT ######################
          programs = {
            git = {
              enable = true;
              userName = "dandeandean";
              userEmail = "dandean44523@gmail.com";
            };
            gh = {
              enable = true;
              gitCredentialHelper.enable = true;
            };
          };

          programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            shellAliases = {
              v = "nvim";
              reload = "source $HOME/.zshrc";
              config = "$EDITOR $HOME/.config/";
              manage = "$EDITOR $HOME/.config/home-manager/";
              nixedit = "$EDITOR $HOME/git/nixos-config";
              nixupdate = "sudo nixos-rebuild switch";
            };
            oh-my-zsh = {
              enable = true;
              plugins = [ "git" ];
            };
            initContent = ''
              source $HOME/git/dotfiles/config/zsh/main.zsh
            '';
          };

          programs.tmux = {
            enable = true;
            clock24 = true;
            plugins = with pkgs.tmuxPlugins; [ yank ];
            extraConfig =
              builtins.readFile /home/ddd/git/dotfiles/config/tmux.conf;
          };

          programs.zoxide = {
            enable = true;
            enableZshIntegration = true;
          };
        };
      };
    };
  };
}
