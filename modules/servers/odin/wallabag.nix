{...}: {
  virtualisation.oci-containers.containers.wallabag = {
    image = "docker.io/wallabag/wallabag:latest";
    autoStart = true;
    ports = [
      "8181:80"
    ];
    environment = {
      "SYMFONY__ENV__DOMAIN_NAME" = "https://wallabag.cronyakatsuki.xyz";
    };
    volumes = [
      "/var/lib/wallabag/data:/var/www/wallabag/data"
      "/var/lib/wallabag/images:/var/www/wallabag/web/assets/images"
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.wallabag.loadBalancer.servers = [
      {
        url = "http://localhost:8181";
      }
    ];

    routers.wallabag = {
      rule = "Host(`wallabag.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "wallabag";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/wallabag"];
    server.paths = ["/var/lib/wallabag"];
  };
}
