{ lib, config, ... }: {
  options.sshBox = {
    enable = lib.mkEnableOption "do ssh?";
    doSecurity = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = {
    services.openssh = {
      enable = config.sshBox.enable;
      ports = [ 22 ];
    };
    services.fail2ban.enable = config.sshBox.doSecurity;
    networking.firewall.enable = config.sshBox.doSecurity;
  };
}
