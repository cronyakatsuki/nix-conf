{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.general-services.enable = lib.mkEnableOption "Enable general services that just should be enabled by default.";
  };

  config = lib.mkIf config.crony.general-services.enable {
    # Enable upower
    services.upower.enable = true;

    # Enable firmware updater
    services.fwupd.enable = true;

    # Enable zram swap device
    zramSwap = {
      enable = true;
      memoryPercent = 60;
    };

    # Setup swapfile
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 32 * 1024;
      }
    ];

    # Setup ntp
    services.timesyncd.enable = true;
  };
}
