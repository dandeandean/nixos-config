{ config, lib, pkgs, ... }: {
  imports = [
    ../users/ddd.nix
    ../common
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/apple-silicon-support
  ];
  config = {
    bloat.enable = false;
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;

    networking.hostName = "leonardo"; # Define your hostname.
    networking.networkmanager.enable = true;
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      neovim
      gh
      tree
      git
    ];

    system.stateVersion = "25.11"; # Don't change
  };
}
