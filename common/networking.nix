{ lib, config, ... }: {
  options = { tailscale.enable = lib.mkEnableOption "Enable Tailscale"; };
  config = { services.tailscale.enable = config.tailscale.enable; };
}
