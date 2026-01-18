{ pkgs, ... }: {
  programs.zsh.enable = true;
  users.users.ddd = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "podman" ]; # Enable ‘sudo’ for the user.
    # Packages handled in home manager
  };
}
