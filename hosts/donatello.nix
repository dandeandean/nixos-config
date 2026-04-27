{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../users/ddd.nix
    ../common
  ];
  config = {
    networking.hostName = "donatello"; # Define your hostname.
    # Don't start sleeping when we close the lid & plugged in
    services.logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
    };
    systemd.sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    isK3sNode.enable = true;
    isK3sNode.isServer = false;
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
