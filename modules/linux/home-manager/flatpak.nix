{
  config,
  lib,
  ...
}: {
  options = {
    crony.flatpak.enable = lib.mkEnableOption "Enable flatpak and install my packages";
  };

  config = lib.mkIf config.crony.flatpak.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "com.github.tchx84.Flatseal"
      ];

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
      uninstallUnmanaged = true;
    };
  };
}
