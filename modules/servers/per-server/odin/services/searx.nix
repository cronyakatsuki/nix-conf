{config, ...}: {
  services.searx = {
    enable = true;
    settings = {
      general.instance_name = "Crony's SearXNG";
      server.port = "8090";
      server.bind_address = "127.0.0.1";
      server.secret_key = "@SEARX_SECRET_KEY@";
      server.public_instance = true;
      server.image_proxy = true;
    };
    uwsgiConfig = {
      http = ":8090";
    };
    redisCreateLocally = true;
    configureUwsgi = true;
    environmentFile = "${config.age.secrets.searx.path}";
  };

  # Setup anubis to block fucking ai bots
  services.anubis.instances.searx = {
    settings = {
      TARGET = "http://127.0.0.1:8090";
      BIND_NETWORK = "tcp";
      BIND = "127.0.0.1:8082";
      SERVE_ROBOTS_TXT = true;
      DIFFICULTY = 5;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.searx.loadBalancer.servers = [
      {
        url = "http://localhost:8082";
      }
    ];

    routers.searx = {
      rule = "Host(`searx.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "searx";
      entrypoints = "websecure";
    };
  };
}
