{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.obs-studio.enable = lib.mkEnableOption "Enable obs and install plugins.";
  };

  config = lib.mkIf config.crony.obs-studio.enable {
    # Install obs-studio
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
      ];
    };
  };
}
