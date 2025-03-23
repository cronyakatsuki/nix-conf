{
  config,
  lib,
  ...
}: {
  imports = [
    ./graphics-tablet.nix
  ];

  options = {
    crony.additional-hardware.enable = lib.mkEnableOption "Enable additional hardware modules.";
  };

  config = lib.mkIf config.crony.additional-hardware.enable {
    crony.additional-hardware.otd.enable = lib.mkDefault true;
  };
}
