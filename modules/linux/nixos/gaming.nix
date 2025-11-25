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
    # Install steam
    programs.steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-custom
      ];
    };
    # Enable gamescope
    programs.gamescope = {
      enable = true;
      # capSysNice = true;
      package = pkgs.gamescope_git;
    };

    # Manage gamescope using ananicy
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp;
      extraRules = [
        {
          "name" = "gamescope";
          "nice" = -20;
        }
      ];
    };

    # Install gamemode
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 10;
        };
        cpu = {
          pin_cores = "no";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    # Setup esync
    systemd.settings.Manager = {
      DefaultLimitNOFILE = 1048576;
    };
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
    ];

    # Setup switch pro controller
    # hardware.steam-hardware.enable = true;
    # services.joycond.enable = true;
  };
}
