{
  config,
  lib,
  ...
}: {
  options = {
    crony.sunshine.enable = lib.mkEnableOption "Enable sunshine";
  };

  config = lib.mkIf config.crony.sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
