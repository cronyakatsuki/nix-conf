{...}: {
  services.redlib = {
    enable = true;
    address = "127.0.0.1";
    settings = {
      ROBOTS_DISABLE_INDEXING = "on";
      THEME = "gruvboxdark";
      USE_HLS = "on";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.redlib.loadBalancer.servers = [
      {
        url = "http://localhost:8080";
      }
    ];

    routers.redlib = {
      rule = "Host(`libreddit.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "redlib";
      entrypoints = "websecure";
    };
  };
}
