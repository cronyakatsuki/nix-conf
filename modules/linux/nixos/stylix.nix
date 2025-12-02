{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    crony.stylix.enable = lib.mkEnableOption "enable stylix and style my system";
  };

  config = lib.mkIf config.crony.stylix.enable {
    # Enable sytling using stylix
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.image = ./tokyonight.png;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

    # Change Cursor
    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.name = "Bibata-Modern-Ice";
    stylix.cursor.size = 32;

    # Fix stuff not automatically using dark theme on websites
    stylix.polarity = "dark";

    # Change u those fonts
    stylix.fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "CommitMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    # Change font sizes
    stylix.fonts.sizes = {
      applications = 15;
      desktop = 13;
      popups = 13;
      terminal = 15;
    };

    # Change chrome settings
    stylix.targets.chromium.enable = false;
  };
}
