{
  config,
  pkgs,
  lib,
  ...
}: let
  theme = pkgs.sddm-astronaut;
in {
  options = {
    crony.sddm.enable = lib.mkEnableOption "Enable sddm.";
  };

  config = lib.mkIf config.crony.sddm.enable {
    environment.systemPackages = [
      theme
    ];
    services.displayManager.sddm = {
      enable = true;
      extraPackages = [theme];
      wayland = {
        enable = true;
      };
      theme = "sddm-astronaut-theme";
    };
  };
}
