# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../users/ddd.nix
    ../../home
  ];

  options.foot.hostName = lib.mkOption {
    type = lib.types.str;
    description = "the hostname for the foot clan instance";
    example = "rocksteady";
  };

  config = {
    networking = {
      hostName = config.foot.hostName;
      networkmanager.enable = true;
    };
    sshBox = {
      enable = true;
      doSecurity = false;
    };
    isK3sNode = {
      enable = true;
      isServer = true;
      joinAsHAServer = true;
    };

    # Boot Loader Settings
    # boot.loader.systemd-boot.enable = true; -- This caused no boot partion to be found
    # Not certain we need this, but we need to be able to find the mmc_drive at boot time
    hardware.enableAllHardware = true;
    boot = {
      loader.efi.canTouchEfiVariables = true;
      initrd.availableKernelModules = [
        "mmc_core"
        "mmc_block"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sdhci"
        "sdhci_pci"
        "sdhci_acpi"
        "rtsx_pci_sdmmc"
      ];
      initrd.kernelModules = [
        "mmc_core"
        "mmc_block"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sdhci"
        "sdhci_pci"
        "sdhci_acpi"
        "rtsx_pci_sdmmc"
      ];
      loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      # We are having a hard time on startup finding a device, but it showed up in grub just fine
      kernelParams = [ "boot.shell_on_fail" ];
    };
    system.stateVersion = "26.05";
  };
}
