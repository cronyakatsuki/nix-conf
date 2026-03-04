{
  config,
  lib,
  ...
}: {
  options = {
    crony.boot.enable = lib.mkEnableOption "Enable and setup kernel related parameters";
  };

  config = lib.mkIf config.crony.boot.enable {
    boot.consoleLogLevel = 3;
    boot.kernelParams = ["quiet" "udev.log_priority=3"];
  };
}
