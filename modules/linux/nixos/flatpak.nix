{
  config,
  lib,
  ...
}: {
  options = {
    crony.flatpak.enable = lib.mkEnableOption "Enable and install flatpak packages.";
  };

  config = lib.mkIf config.crony.flatpak.enable {
    # Enable flatpak
    services.flatpak = {
      enable = true;
      packages = [
        "com.dec05eba.gpu_screen_recorder"
      ];

      uninstallUnmanaged = true;

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
