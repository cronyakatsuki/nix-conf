{
  config,
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
      protontricks
      itch
      wineWowPackages.staging
      osu-lazer-bin
      steam-rom-manager
      bolt-launcher
      space-cadet-pinball
      gzdoom
      qzdl
      zeroad
      xonotic
      superTuxKart
      cataclysm-dda
      nzportable
    ];
  };
}
