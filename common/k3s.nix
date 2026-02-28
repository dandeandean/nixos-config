{ lib, config, ... }:
# This is static,
# so long as it's plugged into the right port on the router...
let hostAddr = "https://10.0.0.10:6443";
in {
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
      # extraFlags =
      #   if config.isK3sNode.isServer then [ "-tls-san=${hostTailIP}" ] else [ ];
      # not sure if this will work on the next startup. I needed to manually edit k3s-servings
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

