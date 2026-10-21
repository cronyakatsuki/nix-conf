{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.gaming.enable = lib.mkEnableOption "Install gaming related packages";
  };

  config = lib.mkIf config.crony.gaming.enable {
    home.packages = with pkgs; [
      heroic
      prismlauncher
      protonup-qt
      itch
      wine-staging
      lutris
    ];
  };
}
