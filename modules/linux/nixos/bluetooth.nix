{
  lib,
  config,
  pkgs,
  ...
}: {
  # Enable bluetooth
  options = {
    crony.bluetooth.enable = lib.mkEnableOption "enable bluetooth";
  };

  config = lib.mkIf config.crony.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez-experimental;

      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    # services.blueman.enable = true;
    environment.systemPackages = [pkgs.overskride];
  };
}
