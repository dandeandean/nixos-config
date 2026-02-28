{ config, lib, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in {
  imports = [ (import "${home-manager}/nixos") ];
  options = { bloat.enable = lib.mkEnableOption "Enable Desktop Environment"; };
  config = {
    home-manager = {
      useGlobalPkgs = true;
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
                k9s
                jq
                tree
                fzf

                ###################### DEV ######################
                uv
                sqlite
                lazygit
                gnumake
                opentofu
                pulumi

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
                ghostty
                firefox
                autotiling-rs
                swaylock
                swayidle
                chromium
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
                modules-right = [ "cpu" "memory" "battery" ];
                battery = { format = "󰁹 {}%"; };
                cpu = {
                  interval = 10;
                  format = "󰻠  {}%";
                  max-length = 10;
                  on-click = "";
                };
                memory = {
                  interval = 30;
                  format = "   {}%";
                  format-alt =
                    "   {used:0.1f}G/{total:0.1f}G"; # Shows GB on click/hover
                  max-length = 10;
                  tooltip = true;
                };
                "sway/workspaces" = {
                  disable-scroll = true;
                  all-outputs = true;
                };
              };
            };
          };
          wayland.windowManager.sway = {
            enable = config.bloat.enable;
            checkConfig = true;
            config = {
              menu = "${pkgs.wofi}/bin/wofi --show drun";
              modifier = "Mod4";
              terminal = "ghostty";
              bars = [{ command = "waybar"; }];
              output = { "eDP-1" = { bg = "${../wallpaper.jpg} fill"; }; };
            };
            extraConfig = ''
              gaps inner 10
              gaps horizontal 10
              gaps vertical 10
              default_border none
              exec ${pkgs.autotiling-rs}/bin/autotiling-rs
              bindgesture swipe:right workspace prev
              bindgesture swipe:left workspace next
              input "type:keyboard" xkb_options caps:escape
              bindsym Mod4+q exec ${pkgs.swaylock}/bin/swaylock
            '';
          };
          programs.swaylock = {
            enable = config.bloat.enable;
            settings = {
              font-size = 26;
              indicator-radius = 50;
              indicator-thickness = 50;
              image = "${../wallpaper.jpg}";
              text-color = "ebdbb2";
              show-failed-attempts = true;
            };
          };
          services.swayidle = {
            enable = config.bloat.enable;
            events = [
              {
                event = "before-sleep";
                command = "${pkgs.swaylock}/bin/swaylock -c 000000";
              }
              {
                event = "lock";
                command = "${pkgs.swaylock}/bin/swaylock -c 000000";
              }
            ];
            timeouts = [
              # Lock screen after 5 minutes
              {
                timeout = 300;
                command = "${pkgs.swaylock}/bin/swaylock -c 000000";
              }
              # Turn off displays after 10 minutes (using swaymsg)
              {
                timeout = 600;
                command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
                resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
              }
            ];
          };
          programs.wofi = {
            enable = true;
            settings = {
              location = "center";
              allow_markup = true;
              width = 400;
            };
            style = builtins.readFile ../styles/wofi.css;
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
