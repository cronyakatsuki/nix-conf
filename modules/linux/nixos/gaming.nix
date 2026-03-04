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
    # Setup ntsync
    boot.kernelModules = ["ntsync"];

    # Install steam
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-cachyos-x86_64_v3
      ];
    };
    # Enable gamescope
    programs.gamescope = {
      enable = true;
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

    # Enable sleepy launcher
    programs.sleepy-launcher.enable = true;

    # Setup switch pro controller
    hardware.steam-hardware.enable = true;
    services.joycond.enable = true;
  };
}
