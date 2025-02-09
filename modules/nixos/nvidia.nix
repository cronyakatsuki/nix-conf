{
  lib,
  pkgs,
  config,
  ...
}: {
  # Allow for nvidia
  options = {
    crony.nvidia.enable = lib.mkEnableOption "enable nvidia";
  };

  config = lib.mkIf config.crony.nvidia.enable {
    # Setup vaapi for nvidia
    hardware.graphics.extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];

    # Setup nvidia drivers
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      prime = {
        offload = {
          enableOffloadCmd = true;
          enable = true;
        };

        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
      };
    };
  };
}
