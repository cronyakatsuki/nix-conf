{...}: {
  services.changedetection-io = {
    enable = true;
    playwrightSupport = true;
    baseURL = "https://changedetection.cronyakatsuki.xyz";
    behindProxy = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    services.changedetection.loadBalancer.servers = [
      {
        url = "http://localhost:5000";
      }
    ];

    routers.changedetection = {
      rule = "Host(`changedetection.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "changedetection";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/changedetection-io"];
    server.paths = ["/var/lib/changedetection-io"];
  };
}
