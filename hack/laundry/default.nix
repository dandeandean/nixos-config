{
  pkgs ? import <nixpkgs> { },
}:

pkgs.buildGo126Module {
  pname = "laundry";
  version = "0.0.1";
  src = ./.;
  vendorHash = "sha256-pW2wRk79IKssxOZgk9cYm5DonlhUNptZ7I+NcvO43Uk=";
  proxyVendor = true;
  subPackages = [ "." ];
  meta = with pkgs.lib; {
    description = "A simple tool to clean up the system";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
