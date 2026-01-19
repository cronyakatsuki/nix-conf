{...}: {
  virtualisation.oci-containers.containers.syncyomi = {
    image = "ghcr.io/syncyomi/syncyomi:latest";
    autoStart = true;
    ports = [
      "8282:8282"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    volumes = [
      "/var/lib/syncyomi:/config"
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.syncyomi.loadBalancer.servers = [
      {
        url = "http://localhost:8282";
      }
    ];

    routers.syncyomi = {
      rule = "Host(`syncyomi.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "syncyomi";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/syncyomi"];
    server.paths = ["/var/lib/syncyomi"];
  };
}
