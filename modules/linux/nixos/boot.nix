{
  config,
  lib,
  ...
}: {
  options = {
    crony.boot.enable = lib.mkEnableOption "Enable and setup kernel related parameters";
  };

  config = lib.mkIf config.crony.boot.enable {
    boot.kernel.sysctl = {
      "vm.swappiness" = 10;
      "kernel.nmi_watchdog" = 0;
    };
    boot.kernelParams = ["quiet"];
  };
}
