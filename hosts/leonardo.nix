{
  ...
}:
{
  imports = [
    ../users/ddd.nix
    ../common
    /etc/nixos/hardware-configuration.nix
  ];
  config = {
    networking.hostName = "leonardo";
    bloat.enable = false;
    sshBox.enable = true;
    sshBox.doSecurity = false;
    isK3sNode.enable = true;
    isK3sNode.isServer = false;
    tailscale.enable = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;
    system.stateVersion = "25.11"; # Don't change
  };
}
