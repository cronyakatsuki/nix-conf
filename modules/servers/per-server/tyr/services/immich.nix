{...}: {
  services.immich = {
    enable = true;
    port = 2283;
    host = "127.0.0.1";
    openFirewall = true;
    mediaLocation = "/mnt/adata-hdd/immich";
    machine-learning.enable = true;
    database.enable = true;
    redis.enable = true;
    accelerationDevices = ["/dev/dri/renderD128"];
  };

  users.users.immich.extraGroups = ["video" "render"];

  # Ensure the data dir exists and is owned by immich before the service starts.
  systemd.tmpfiles.rules = [
    "d /mnt/adata-hdd/immich 0750 immich immich -"
  ];

  systemd.services.immich-server = {
    after = ["mnt-adata\\x2dhdd.mount"];
    requires = ["mnt-adata\\x2dhdd.mount"];
  };
  # Same for the ML service if enabled:
  systemd.services.immich-machine-learning = {
    after = ["mnt-adata\\x2x2dhdd.mount"];
    requires = ["mnt-adata\\x2dhdd.mount"];
  };
}
