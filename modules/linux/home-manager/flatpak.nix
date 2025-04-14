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
        "com.albiononline.AlbionOnline"
        "app.zen_browser.zen"
        "com.usebottles.bottles"
      ];

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
