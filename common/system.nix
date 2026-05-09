{ pkgs, ... }:
let
  laundryFlake = builtins.getFlake (toString ../hack/laundry);
  laundryPkg = laundryFlake.packages.${pkgs.system}.default;
in
{
  config = {
    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "ter-i32b";
      packages = [ pkgs.terminus_font ];
    };
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    system.copySystemConfiguration = true;
    networking.networkmanager.enable = true;
    programs.zsh.enable = true;
    environment.systemPackages =
      with pkgs;
      [
        # Utils
        laundryFlake.packages.${system}.default

        # System
        wget
        kubernetes
        kubectl
        kubernetes-helm
        kompose
        python3
        htop
        nmap
        git
        fluxcd
        tailscale

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
        nixfmt
      ]
      ++ lib.optionals (builtins.currentSystem == "aarch64-linux") [ gcc ]
      ++ lib.optionals (builtins.currentSystem == "x86_64-linux") [ gcc_multi ];

    systemd.timers."laundry-service" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
    systemd.services."laundry-service" = {
      wantedBy = [ "timers.target" ];
      serviceConfig = {
        ExecStart = "${laundryPkg}/bin/laundry";
        Type = "oneshot";
        User = "root";
        # This is likely a crime of some sort
        Environment = "PATH=/run/current-system/sw/bin:${pkgs.coreutils}/bin";
      };
    };
  };
}
