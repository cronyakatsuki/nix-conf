{
  config,
  lib,
  ...
}: {
  options = {
    crony.sddm.enable = lib.mkEnableOption "Enable sddm.";
  };

  config = lib.mkIf config.crony.sddm.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
  };
}
