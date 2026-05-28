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
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };

    security.pam.services.hyprlock = {};
    security.pam.services.waylock = {};
  };
}
