{ lib, config, ... }:
let do_security = false;
in {
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
    services.fail2ban.enable = do_security;
    networking.firewall.enable = do_security;
  };
}
