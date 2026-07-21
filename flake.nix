{
  description = "flake for homelab";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    apple-silicon.url = "github:nix-community/nixos-apple-silicon";
  };

  outputs =
    {
      self,
      nixpkgs,
      apple-silicon,
    }@inputs:
    {
      nixosConfigurations = {
        # Rebuild with:
        # nixos-rebuild --flake .#michelangelo switch --show-trace --impure
        # The impure is from absolute paths to hardware
        michelangelo = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "aarch64-linux";
          modules = [
            apple-silicon.nixosModules.apple-silicon-support
            ./hosts/michelangelo/michelangelo.nix
          ];
        };
        splinter = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/splinter/configuration.nix
          ];
        };
        raphael = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/raphael/configuration.nix
          ];
        };
        donatello = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/donatello/configuration.nix
          ];
        };

        rocksteady = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ({ ... }: {
              foot.hostName = "rocksteady";
            })
            ./hosts/clones/configuration.nix
          ];
        };
        bebop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ({ ... }: {
              foot.hostName = "bebop";
            })
            ./hosts/clones/configuration.nix
          ];
        };
        krang = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ({ ... }: {
              foot.hostName = "krang";
            })
            ./hosts/clones/configuration.nix
          ];
        };
      };
    };
}
