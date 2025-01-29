{
  lib,
  config,
  ...
}: {
  # Allow for nvidia
  options = {
    crony.nvidia.enable = lib.mkEnableOption "enable nvidia";
  };

  config = lib.mkIf config.crony.nvidia.enable {
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.open = false;
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.powerManagement.enable = true;
    hardware.nvidia.nvidiaSettings = true;
    hardware.nvidia.prime = {
      offload = {
        enableOffloadCmd = true;
        enable = true;
      };

      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
    };
  };
}
