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
      protontricks
      itch
      wineWowPackages.staging
      inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable
      gzdoom
      qzdl
      xonotic
      superTuxKart
      faugus-launcher
      # nzportable
    ];
  };
}
