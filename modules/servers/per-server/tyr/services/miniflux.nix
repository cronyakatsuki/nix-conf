{config, ...}: {
  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "127.0.0.1:8000";
      BASE_URL = "https://feed.cronyakatsuki.xyz";
      FETCH_YOUTUBE_WATCH_TIME = "1";
    };
    adminCredentialsFile = "${config.age.secrets.miniflux.path}";
  };

  services.postgresqlBackup = {
    enable = true;
    databases = ["miniflux"];
  };

  services.restic.backups = {
    local.paths = ["/var/backup/postgresql"];
    server.paths = ["/var/backup/postgresql"];
  };
}
