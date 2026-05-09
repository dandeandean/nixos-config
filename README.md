# NixOS Config

This repository contains NixOS configurations for a home lab environment, using Flakes and Home Manager.

The cluster consists of 5 hosts:
- **Splinter, Leonardo, & Raphael**: Joined in a K3s cluster.
- **Michelangelo & Leonardo**: Apple Silicon (Asahi Linux) machines.
- **Donatello**: General purpose node.

## Usage

This configuration uses Nix Flakes for centralized management.

### Update System
To update a host, run:
```bash
sudo nixos-rebuild switch --flake .#<hostname> --impure
```
Replace `<hostname>` with one of: `michelangelo`, `leonardo`, `donatello`, `raphael`, or `splinter`.

### Update Flake Inputs
To update the dependencies (nixpkgs, home-manager, etc.):
```bash
nix flake update
```

## Structure

- `hosts/`: Machine-specific configurations.
- `common/`: Shared modules for system settings, Home Manager, K3s, and networking.
- `users/`: User-specific NixOS settings (e.g., `ddd.nix`).
- `flake.nix`: Main entry point for the configuration.

## Legacy Usage (Non-Flake)
The system's `/etc/nixos/configuration.nix` can still import host files directly if needed:

```nix
{ config, lib, pkgs, ... }:
{
  imports =
    [
      /home/ddd/git/nixos-config/hosts/splinter.nix
    ];
}
```
