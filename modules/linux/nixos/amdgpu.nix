{
  config,
  lib,
  ...
}: {
  options = {
    crony.amdgpu.enable = lib.mkEnableOption "Load amdgpu modules at boot.";
  };

  config = lib.mkIf config.crony.amdgpu.enable {
    # Try to fix amdgpu
    boot.initrd.kernelModules = ["amdgpu"];
    services.xserver.videoDrivers = ["amdgpu"];
  };
}
