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

  services.traefik.dynamicConfigOptions.http = {
    services.miniflux.loadBalancer.servers = [
      {
        url = "http://localhost:8000";
      }
    ];

    routers.miniflux = {
      rule = "Host(`feed.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "miniflux";
      entrypoints = "websecure";
    };
  };
}
