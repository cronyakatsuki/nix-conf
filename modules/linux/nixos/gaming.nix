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
    # programs.gamemode = {
    #   enable = true;
    #   enableRenice = true;
    #   settings = {
    #     general = {
    #       softrealtime = "auto";
    #       renice = 10;
    #     };
    #     cpu = {
    #       pin_cores = "no";
    #     };
    #     custom = {
    #       start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
    #       end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
    #     };
    #   };
    # };

    services.udev.extraRules = ''
      SUBSYSTEM=="powercap", KERNEL=="intel-rapl:0", RUN+="${pkgs.coreutils}/bin/chgrp wheel /sys/%p/energy_uj", RUN+="${pkgs.coreutils}/bin/chmod g+r /sys/%p/energy_uj"
    '';

    # Setup esync
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
    ];

    # Setup switch pro controller
    hardware.steam-hardware.enable = true;
    services.joycond.enable = true;
  };
}
