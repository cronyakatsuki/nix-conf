{
  config,
  pkgs,
  ...
}: {
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  home.packages = [
    pkgs.sesh
    pkgs.tree-sitter
  ];

  programs.vesktop.enable = true;

  home.sessionVariables = {
  };

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

  programs.nh = {
    enable = true;
    flake = "/home/crony/repos/nix-conf";
    homeFlake = "/home/crony/repos/nix-conf";
  };

  targets.genericLinux = {
    enable = true;
    gpu.nvidia = {
      enable = true;
      version = "590.48.01";
      sha256 = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  home.stateVersion = "25.11"; # Please read the comment before changing.
}
