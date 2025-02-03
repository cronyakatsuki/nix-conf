{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.sddm.enable = lib.mkEnableOption "Enable sddm.";
  };

  config = lib.mkIf config.crony.sddm.enable {
    environment.systemPackages = [
      (pkgs.where-is-my-sddm-theme.override {
        variants = ["qt6" "qt5"];
        themeConfig.General = {
          showSessionsByDefault = true;

          background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          backgroundFill = "#282828";
          backgroundMode = "none";
        };
      })
    ];
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "where_is_my_sddm_theme_qt5";
    };
  };
}
