{
  description = "flake for homelab";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs =
    { self, nixpkgs }:
    {
      nixosConfigurations = {
        michelangelo = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/michelangelo.nix
          ];
        };
      };
    };
}
