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
        "com.usebottles.bottles"
        "com.github.tchx84.Flatseal"
        "cafe.avery.Delfin"
      ];

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
