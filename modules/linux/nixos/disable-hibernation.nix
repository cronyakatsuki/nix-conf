{
  config,
  lib,
  ...
}: {
  options = {
    crony.hibernation.disable = lib.mkEnableOption "disable hibernation and friends";
  };
  config = lib.mkIf config.crony.hibernation.disable {
    # Disable hibernation, sleep and other friends
    systemd.targets = {
      sleep = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      suspend = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      hibernate = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      "hybrid-sleep" = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };
  };
}
