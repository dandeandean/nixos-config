{ lib, config, ... }:
let
  hostAddr = "https://10.0.0.10:6443";
  hostTailIP = "100.90.89.66";
in {
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
    isServer = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description =
        "Which role would you like the node to have: server or agent?";
    };
  };
  config = {
    networking.firewall.allowedTCPPorts = [
      6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
      2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    ];
    networking.firewall.allowedUDPPorts = [
      8472 # k3s, flannel: required if using multi-node for inter-node networking
    ];
    services.k3s = {
      enable = config.isK3sNode.enable;
      role = if config.isK3sNode.isServer then "server" else "agent";
      serverAddr = if config.isK3sNode.isServer then "" else hostAddr;
      clusterInit = config.isK3sNode.isServer;
      token = builtins.readFile /home/ddd/.kube/cluster-secret;
      extraFlags =
        if config.isK3sNode.isServer then [ "-tls-san=${hostTailIP}" ] else [ ];
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

