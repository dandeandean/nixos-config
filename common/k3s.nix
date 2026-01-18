{ lib, config, ... }: {
  /* STARTUP ISSUES: This seems to be what is causing the node startup issues.
       https://github.com/k3s-io/k3s/issues/12844
       https://dev.to/shankar_t/my-k3s-pi-cluster-died-after-a-reboot-a-troubleshooting-war-story-m93
     systemd.services."k3s.service".requires = [ "network-setup.service" ];
     From https://discourse.nixos.org/t/how-do-i-set-up-k3s-on-nixos/52056/2
  */
  # Options: https://search.nixos.org/options?channel=unstable&show=services.k3s.extraKubeletConfig&query=k3s
  # Good intro to options: https://librephoenix.com/2023-12-26-nixos-conditional-config-and-custom-options
  options.isK3sNode = {
    enable = lib.mkEnableOption "Enable the K3S service on host";
    role = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "master" "employee" ]);
      default = null;
      description = "Which role would you like the node to have?";
    };
  };
  config = {
    services.k3s = {
      enable = (lib.mkIf config.isK3sNode.enable true);
      # extraFlags = [ "--disable-network-policy" ];
    };
    virtualisation = {
      containers.enable = true;
      containerd.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}

