{ ... }: {
  imports =
    [ ./home-manager.nix ./k3s.nix ./system.nix ./ssh.nix ./networking.nix ];
}
