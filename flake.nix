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
        # Rebuild with:
        # nixos-rebuild --flake .#michelangelo switch --show-trace --impure
        # The impure is from absolute paths to hardware
        michelangelo = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/michelangelo.nix
          ];
        };
      };
    };
}
