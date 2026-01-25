{
  config,
  lib,
  ...
}: {
  options = {
    crony.pc-services.enable = lib.mkEnableOption "Enable and setup pc related service for gpu/fan/rgb management.";
  };

  config = lib.mkIf config.crony.pc-services.enable {
    # Enable coolercontrol to setup fancurves
    programs.coolercontrol = {
      enable = true;
    };

    # Setup gpu fan curves and light undervolt
    services.lact.enable = true;

    # Setup display brightness changing using ddcutil
    hardware.i2c.enable = true;

    # Setup rgb control
    services.hardware.openrgb.enable = true;

    # Needed modules to have fan control
    boot.kernelModules = ["coretemp" "nct6775"];
  };
}
