{
  config,
  inputs,
  lib,
  ...
}: {
  options = {
    crony.cachyos.settings.enable = lib.mkEnableOption "Enable and setup cachyos settings.";
  };

  config = lib.mkIf config.crony.cachyos.settings.enable {
    cachyos.settings = {
      enable = true;
      nvidia.enable = true;
    };
  };
}
