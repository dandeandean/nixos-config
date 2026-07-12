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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJLGrAmWUM5x9OcD6WT0Y2vqT7udXQR4TkKkxwNKd50"
    ];
  };
}
