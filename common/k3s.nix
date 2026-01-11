{ ... }: {
  services.k3s.enable = true;
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

