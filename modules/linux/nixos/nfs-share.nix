{
  config,
  lib,
  ...
}: {
  options = {
    crony.nfs-share.enable = lib.mkEnableOption "Setup personal nfs share mount.";
  };

  config = lib.mkIf config.crony.nfs-share.enable {
    # Nfs share
    fileSystems."/mnt/share" = {
      device = "192.168.0.4:/mnt/nfs";
      fsType = "nfs";
      options = ["_netdev" "noauto" "x-systemd.automount" "x-systemd.mount-timeout=10" "timeo=14" "x-systemd.idle-timeout=600"];
    };
  };
}
