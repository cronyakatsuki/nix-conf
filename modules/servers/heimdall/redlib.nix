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

  # Setup anubis to block fucking ai bots
  services.anubis.instances.redlib = {
    settings = {
      TARGET = "http://127.0.0.1:8080";
      BIND_NETWORK = "tcp";
      BIND = "127.0.0.1:8081";
      SERVE_ROBOTS_TXT = true;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.redlib.loadBalancer.servers = [
      {
        url = "http://localhost:8081";
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
