{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
  };

  services.restic.backups = {
    local.paths = ["/var/lib/syncthing"];
    server.paths = ["/var/lib/syncthing"];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.syncthing.loadBalancer.servers = [
      {
        url = "http://localhost:8384";
      }
    ];

    routers.syncthing = {
      rule = "Host(`syncthing.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "syncthing";
      entrypoints = "websecure";
    };
  };
}
