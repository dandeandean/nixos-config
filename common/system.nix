{ pkgs, ... }: {
  config = {
    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "ter-i32b";
      packages = [ pkgs.terminus_font ];
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    system.copySystemConfiguration = true;
    programs.zsh.enable = true;
    environment.systemPackages = with pkgs;
      [
        # System
        wget
        kubernetes
        kubectl
        kompose
        python3
        htop
        nmap
        git

        # Editing
        vim
        neovim
        ripgrep
        zk
        luarocks
        lua
        rustc
        cargo
        go
        nodejs_22
        unzip
        nixfmt-classic
      ] ++ lib.optionals (builtins.currentSystem == "aarch64-linux") [ gcc ]
      ++ lib.optionals (builtins.currentSystem == "X86_64-linux") [ gcc_multi ];
  };
}
