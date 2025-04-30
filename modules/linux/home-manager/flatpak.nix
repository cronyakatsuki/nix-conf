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
        "com.usebottles.bottles"
        "com.github.tchx84.Flatseal"
        "org.diasurgical.DevilutionX"
        "cafe.avery.Delfin"
        "org.vinegarhq.Sober"
      ];

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
