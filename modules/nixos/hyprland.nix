{
  config,
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
      withUWSM = true;
    };

    security.pam.services.hyprlock = {};
  };
}
