{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.sunshine.enable = lib.mkEnableOption "Enable sunshine";
  };

  config = lib.mkIf config.crony.sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Desktop";
            auto-detach = "true";
            image-path = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            detached = [
              "${pkgs.steam} -tenfoot"
            ];
            image-path = "steam.png";
          }
        ];
      };
    };
  };
}
