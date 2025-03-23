{
  config,
  lib,
  ...
}: {
  options = {
    crony.watchdog.disable = lib.mkEnableOption "Disable watchdog for my laptop.";
  };

  config = lib.mkIf config.crony.watchdog.disable {
    boot.kernelParams = ["nmi_watchdog=0"];
    boot.blacklistedKernelModules = ["sp5100_tco"];
  };
}
