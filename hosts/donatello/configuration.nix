{
  ...
}:
{
  imports = [
    ../../users/ddd.nix
    ../../common
    ./hardware-configuration.nix
  ];
  config = {
    networking.hostName = "donatello"; # Define your hostname.
    # Don't start sleeping when we close the lid & plugged in
    services.logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
    };
    systemd.sleep.settings = {
      Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
        AllowHybridSleep = "no";
        AllowSuspendThenHibernate = "no";
      };
    };
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    sshBox.enable = true;
    sshBox.doSecurity = false;
    isK3sNode.enable = true;
    isK3sNode.isServer = false;
    tailscale.enable = true;
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
