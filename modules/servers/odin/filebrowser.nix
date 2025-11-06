{
  services.filebrowser = {
    enable = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    services.filebrowser.loadBalancer.servers = [
      {
        url = "http://localhost:8080";
      }
    ];

    routers.filebrowser = {
      rule = "Host(`filebrowser.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "filebrowser";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/filebrowser"];
    server.paths = ["/var/lib/filebrowser"];
  };
}
