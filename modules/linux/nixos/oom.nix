{
  config,
  lib,
  ...
}: {
  options = {
    crony.oom.enable = lib.mkEnableOption "Enable and setup settings for better oom management on a desktop system and nix build.";
  };

  config = lib.mkIf config.crony.oom.enable {
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
    };
  };
}
