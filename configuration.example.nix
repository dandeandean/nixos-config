{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      /home/ddd/git/nixos-config/hosts/splinter.nix
    ];
}
