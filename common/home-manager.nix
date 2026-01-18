{ lib, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  home-man-dir = /home/ddd/git/dotfiles/config/home-manager/home.nix;
in {
  imports = [ (import "${home-manager}/nixos") ];
  options.desktopEnv = {
    enable = lib.mkEnableOption "Enable desktop environment on host (bloat)";
  };
  config = {
    home-manager = {
      backupFileExtension = "bkp";
      users.ddd = { pkgs, ... }: {
        home.stateVersion = "25.05";
        imports = [ home-man-dir ];
      };
    };
  };
}
