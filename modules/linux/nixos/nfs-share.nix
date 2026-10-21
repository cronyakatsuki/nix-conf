{
  config,
  pkgs,
  lib,
  ...
}: let
  auto_mount = pkgs.writeShellScriptBin "auto_mount" ''
    timeout 1 ${pkgs.bash}/bin/bash -c ": < /dev/tcp/192.168.0.5/2049"

    if [ $? -ne 0 ]; then
      systemctl stop mnt-share.automount
      echo "Nas device not available"
    else
      systemctl start mnt-share.automount
      echo "Nas device available"
    fi
    exit 0
  '';
in {
  options = {
    crony.nfs-share.enable = lib.mkEnableOption "Setup personal nfs share mount.";
  };

  config = lib.mkIf config.crony.nfs-share.enable {
    # Nfs share
    fileSystems."/mnt/share" = {
      device = "192.168.0.5:/export/nfs";
      fsType = "nfs";
      options = ["_netdev" "noauto" "x-systemd.automount" "x-systemd.mount-timeout=10" "timeo=14" "x-systemd.idle-timeout=600"];
    };

    fileSystems."/mnt/roms" = {
      device = "192.168.0.5:/mnt/adata-hdd";
      fsType = "nfs";
      options = ["_netdev" "noauto" "x-systemd.automount" "x-systemd.mount-timeout=10" "timeo=14" "x-systemd.idle-timeout=600"];
    };

    systemd.timers.auto_mount = {
      enable = true;
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
      };
      wantedBy = ["timers.target"];
    };

    systemd.services.auto_mount = {
      serviceConfig.Type = "oneshot";
      serviceConfig.ExecStart = "${auto_mount}/bin/auto_mount";
    };
  };
}
