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
      inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable
      xonotic
      supertuxkart
      faugus-launcher
      nzportable
      protonup-qt
      wine-staging
      sm64coopdx
    ];
  };
}
