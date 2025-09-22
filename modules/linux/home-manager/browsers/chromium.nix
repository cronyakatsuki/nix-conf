{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.browsers.chromium.enable = lib.mkEnableOption "Enable chromium";
  };

  config = lib.mkIf config.crony.browsers.chromium.enable {
    # Enable theming chromium + use ungoogled chromium package
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      # Fix for wayland
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
      ];
    };
  };
}
