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
      remotes = lib.mkOptionDefault [
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];
      packages = [
        "com.github.tchx84.Flatseal"
        "com.stremio.Stremio"
        "org.raspberrypi.rpi-imager"
        "net.shadps4.shadPS4"
        "com.bambulab.BambuStudio"
        "net.rpcs3.RPCS3"
      ];

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
      uninstallUnmanaged = true;
    };
  };
}
