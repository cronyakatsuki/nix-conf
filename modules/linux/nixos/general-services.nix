{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.general-services.enable = lib.mkEnableOption "Enable general services that just should be enabled by default.";
  };

  config = lib.mkIf config.crony.general-services.enable {
    # Enable upower
    services.upower.enable = true;

    # Enable firmware updater
    services.fwupd.enable = true;

    # Setup fstrim
    services.fstrim.enable = true;

    # Enable seatd
    services.seatd.enable = true;

    # Enable ratbagd to customize mouse options
    services.ratbagd.enable = true;

    # Enable dconf
    programs.dconf.enable = true;

    # Enable gnome keyring
    services.gnome.gnome-keyring.enable = true;

    # Setup dbus broker
    services.dbus.implementation = "broker";
  };
}
