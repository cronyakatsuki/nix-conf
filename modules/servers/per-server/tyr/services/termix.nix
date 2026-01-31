{
  virtualisation.oci-containers.containers.termix = {
    image = "ghcr.io/lukegus/termix:latest";
    autoStart = true;
    ports = [
      "8484:8484"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    volumes = [
      "/var/lib/termix:/app/data:U"
    ];
    extraOptions = ["--network=host"];
    environment.PORT = "8484";
  };

  services.restic.backups = {
    local.paths = ["/var/lib/termix"];
    server.paths = ["/var/lib/termix"];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.termix.loadBalancer.servers = [
      {
        url = "http://localhost:8484";
      }
    ];

    routers.termix = {
      rule = "Host(`termix.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "termix";
      entrypoints = "websecure";
    };
  };
}
