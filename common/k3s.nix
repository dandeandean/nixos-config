{ ... }: {
  /* STARTUP ISSUES: This seems to be what is causing the node startup issues.
       https://github.com/k3s-io/k3s/issues/12844
       https://dev.to/shankar_t/my-k3s-pi-cluster-died-after-a-reboot-a-troubleshooting-war-story-m93
     systemd.services."k3s.service".requires = [ "network-setup.service" ];
     From https://discourse.nixos.org/t/how-do-i-set-up-k3s-on-nixos/52056/2
  */
  # Options: https://search.nixos.org/options?channel=unstable&show=services.k3s.extraKubeletConfig&query=k3s
  services.k3s = {
    enable = true;
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
}

