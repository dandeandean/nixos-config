{ pkgs, ... } : {
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
     git

     # Editing
     vim
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
 }
