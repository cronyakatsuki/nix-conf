{
  config,
  lib,
  ...
}: {
  options = {
    crony.kanata.enable = lib.mkEnableOption "Enable and setup kanata";
  };

  config = lib.mkIf config.crony.kanata.enable {
    hardware.uinput.enable = true;
    services.kanata = {
      enable = true;
      keyboards."based".config = ''
        (defsrc
          caps)

        (deflayermap (default-layer)
          ;; tap caps lock as caps lock, hold caps lock as left control
          caps (tap-hold 1 200 esc lctl))
      '';
    };
  };
}
