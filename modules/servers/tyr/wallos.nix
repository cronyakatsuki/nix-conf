{
  virtualisation.oci-containers.containers.wallos = {
    image = "docker.io/bellamy/wallos:latest";
    autoStart = true;
    ports = [
      "8282:80/tcp"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    volumes = [
      "/var/lib/wallos/db:/var/www/html/db"
      "/var/lib/wallos/logos:/var/www/html/images/uploads/logos"
    ];
  };

  services.restic.backups = {
    local.paths = ["/var/lib/wallos"];
    server.paths = ["/var/lib/wallos"];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.wallos.loadBalancer.servers = [
      {
        url = "http://localhost:8282";
      }
    ];

    routers.wallos = {
      rule = "Host(`wallos.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "wallos";
      entrypoints = "websecure";
    };
  };
}
