{ ... }: {
  time.timeZone = "America/New_York";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.copySystemConfiguration = true;
}
