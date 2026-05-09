{ pkgs, ... }:
{
  imports = [
    ../users/ddd.nix
    ../common
    /etc/nixos/hardware-configuration.nix
  ];
  config = {
    networking.hostName = "michelangelo";
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;
    networking.networkmanager.enable = true; # nmcli
    environment.systemPackages = with pkgs; [
      vim
      wget
      gh
      git
      neovim
    ];
    system.stateVersion = "25.11"; # Did you read the comment?
    hardware = {
      apple.touchBar = {
        enable = true;
      };
      graphics = {
        enable = true;
      };
    };
    # Tailscale
    tailscale.enable = true;
    # GUI
    # If you need to share your screen, this is what you want
    # xdg.portal.wlr.enable = true;
    # The following is needed for swaylock to work
    bloat.enable = true;
    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };
}
