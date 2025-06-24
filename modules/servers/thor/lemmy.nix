{...}: {
  services.traefik.dynamicConfigOptions.http = {
    services.lemmy.loadBalancer.servers = [
      {
        url = "http://localhost:1236";
      }
    ];

    routers.lemmy = {
      rule = "Host(`lemmy.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "lemmy";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/lemmy"];
    server.paths = ["/var/lib/lemmy"];
  };
}
