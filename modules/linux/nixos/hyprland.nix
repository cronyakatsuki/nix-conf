{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.hyprland-nixos.enable = lib.mkEnableOption "Enable hyprland globally";
  };

  config = lib.mkIf config.crony.hyprland-nixos.enable {
    programs.uwsm = {
      enable = true;

      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };

    security.pam.services.hyprlock = {};
  };
}
