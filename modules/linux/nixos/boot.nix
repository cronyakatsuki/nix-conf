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
      # Cachy os adopted values
      "vm.swappiness" = 100;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_bytes" = 268435456;
      "vm.page-cluster" = 1;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_writeback_centisecs" = 1500;
      "net.core.netdev_max_backlog" = 4096;
      "fs.file-max" = 2097152;
      # Disable watchdog
      "kernel.nmi_watchdog" = 0;
    };
    boot.kernelParams = ["quiet"];
  };
}
