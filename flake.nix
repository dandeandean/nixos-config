{
  description = "NixOS configuration with Flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, apple-silicon, ... }@inputs:
    let
      mkSystem = { hostname, system, isAppleSilicon ? false }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/${hostname}.nix ]
            ++ nixpkgs.lib.optional isAppleSilicon
            apple-silicon.nixosModules.apple-silicon-support;
        };
    in {
      nixosConfigurations = {
        michelangelo = mkSystem {
          hostname = "michelangelo";
          system = "aarch64-linux";
          isAppleSilicon = true;
        };
        leonardo = mkSystem {
          hostname = "leonardo";
          system = "aarch64-linux";
          isAppleSilicon = true;
        };
        donatello = mkSystem {
          hostname = "donatello";
          system = "x86_64-linux";
        };
        raphael = mkSystem {
          hostname = "raphael";
          system = "x86_64-linux";
        };
        splinter = mkSystem {
          hostname = "splinter";
          system = "x86_64-linux";
        };
      };
    };
}
