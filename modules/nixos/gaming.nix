{
  config,
  pkgs,
  lib,
  ...
}: {
  # Getting gaming setup
  options = {
    crony.gaming.enable = lib.mkEnableOption "enable gaming related stuff, like steam and gamemode";
  };
  config = lib.mkIf config.crony.gaming.enable {
    environment.systemPackages = with pkgs; [
      mangohud
    ];
    # Install steam
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    # Enable gamescope
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
    # Install gamemode
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "on";
          renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    # Setup esync
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
    ];
  };
}
