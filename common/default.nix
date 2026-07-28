{ ... }:
{
  imports = [
    ./k3s.nix
    ./system.nix
    ./ssh.nix
    ./networking.nix
  ];
}
