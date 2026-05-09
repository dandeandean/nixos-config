{
  description = "Laundry - a system cleanup tool built with the latest Go";
  inputs = {
    # We pull from nixpkgs-unstable to ensure we get the latest Go compiler
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Utility functions for flake-compatible systems
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    # This helper iterates over common systems (x86_64-linux, aarch64-linux, etc.)
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.buildGoModule {
          pname = "laundry";
          version = "0.0.1";
          src = ./.;

          # If you upgrade Go and the build fails, update this hash
          vendorHash = "sha256-pW2wRk79IKssxOZgk9cYm5DonlhUNptZ7I+NcvO43Uk=";

          proxyVendor = true;
          subPackages = [ "." ];

          meta = with pkgs.lib; {
            description = "A simple tool to clean up the system";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };

        # This allows you to run 'nix develop' to get a shell with Go
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.go
            pkgs.gopls
          ];
        };
      }
    );
}
