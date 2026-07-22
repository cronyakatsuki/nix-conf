{
  config,
  pkgs,
  ...
}: {
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  crony.restic.enable = true;
  crony.home-secrets.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/crony/repos/nix-conf";
    homeFlake = "/home/crony/repos/nix-conf";
  };

  home.packages = with pkgs; [
    copilot-language-server
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.11"; # Please read the comment before changing.
}
