{
  pkgs,
  inputs,
  ...
}: {
  # Read the changelog before changing this value
  home.stateVersion = "24.05";

  # Import modules I need
  imports = [
    ../../modules/cross-platform/home-manager
    inputs.nix-index-database.homeModules.nix-index
  ];

  stylix = {
    enable = true;
    image = null;
    imageScalingMode = "fill";
    polarity = "dark";
    override = {};
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    autoEnable = false;
    cursor = null;
    fonts = rec {
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "Dejavu Sans";
      };
      serif = sansSerif;
      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "CommitMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        desktop = 10;
        terminal = 10;
        applications = 10;
      };
    };
  };
}
