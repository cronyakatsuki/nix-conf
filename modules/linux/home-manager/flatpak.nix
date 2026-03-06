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
        {
          appId = "com.stremio.Stremio";
          origin = "flathub-beta";
        }
        "org.raspberrypi.rpi-imager"
        # "com.hypixel.HytaleLauncher"
      ];

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
      uninstallUnmanaged = true;
    };
  };
}
