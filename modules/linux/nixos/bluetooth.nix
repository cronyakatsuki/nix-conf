{
  lib,
  config,
  ...
}: {
  # Enable bluetooth
  options = {
    crony.bluetooth.enable = lib.mkEnableOption "enable bluetooth";
  };

  config = lib.mkIf config.crony.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    hardware.bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    services.blueman.enable = true;
  };
}
