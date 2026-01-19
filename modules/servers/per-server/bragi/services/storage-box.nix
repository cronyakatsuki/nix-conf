{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.rclone];

  fileSystems."/mnt" = {
    device = "storage:";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=${config.age.secrets.rclone.path}"
    ];
  };
}
