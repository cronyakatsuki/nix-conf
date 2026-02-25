{
  config,
  pkgs,
  ...
}: {
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  home.packages = [
    pkgs.sesh
  ];

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.nh = {
    enable = true;
    flake = "/home/crony/repos/nix-conf";
    homeFlake = "/home/crony/repos/nix-conf";
  };

  home.stateVersion = "25.11"; # Please read the comment before changing.
}
