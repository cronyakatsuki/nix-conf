{
  config,
  lib,
  ...
}: {
  options = {
    crony.additional-hardware.otd.enable = lib.mkEnableOption "Enable OpenTabletDriver";
  };

  config = lib.mkIf config.crony.additional-hardware.otd.enable {
    # Setup OpenTabletDriver graphic tablet driver
    hardware.opentabletdriver.enable = true;
  };
}
