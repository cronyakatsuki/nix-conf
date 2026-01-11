{
  services.komga = {
    enable = true;
    settings.server.port = 8081;
  };

  services.traefik.dynamicConfigOptions.http = {
    services.komga.loadBalancer.servers = [
      {
        url = "http://localhost:8081";
      }
    ];

    routers.komga = {
      rule = "Host(`komga.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "komga";
      entrypoints = "websecure";
    };
  };
}
