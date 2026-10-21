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

    # setup gaming device udev rules
    services.udev = {
      extraRules = ''
        SUBSYSTEM=="powercap", KERNEL=="intel-rapl:0", RUN+="${pkgs.coreutils}/bin/chgrp wheel /sys/%p/energy_uj", RUN+="${pkgs.coreutils}/bin/chmod g+r /sys/%p/energy_uj"
      '';
      packages = with pkgs; [
        game-devices-udev-rules
      ];
    };
    hardware.uinput.enable = true;

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
