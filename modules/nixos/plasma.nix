{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    crony.plasma.enable = lib.mkEnableOption "enable plasma";
  };

  config = lib.mkIf config.crony.plasma.enable {
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
    ];
  };
}
