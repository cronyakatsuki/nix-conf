{...}: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "127.0.0.1";
    };
  };
  services.traefik.dynamicConfigOptions.http = {
    services.uptime-kuma.loadBalancer.servers = [
      {
        url = "http://localhost:3001";
      }
    ];

    routers.uptime-kuma = {
      rule = "Host(`uptime.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "uptime-kuma";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/uptime-kuma"];
    server.paths = ["/var/lib/uptime-kuma"];
  };
}
