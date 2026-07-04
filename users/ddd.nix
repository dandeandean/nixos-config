{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users.users.ddd = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "podman"
    ];
  };
}
