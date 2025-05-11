{config, ...}: {
  services.searx = {
    enable = true;
    settings = {
      general.instance_name = "Crony's SearXNG";
      server.port = "8090";
      server.bind_address = "127.0.0.1";
      server.secret_key = "@SEARX_SECRET_KEY@";
    };
    uwsgiConfig = {
      http = ":8090";
    };
    redisCreateLocally = true;
    runInUwsgi = true;
    environmentFile = "${config.age.secrets.searx.path}";
  };

  services.traefik.dynamicConfigOptions.http = {
    services.searx.loadBalancer.servers = [
      {
        url = "http://localhost:8090";
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
