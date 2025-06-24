{config, ...}: {
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/mnt/music";
      BaseUrl = "https://nd.cronyakatsuki.xyz";
    };
    environmentFile = "${config.age.secrets.navidrome.path}";
  };

  services.traefik.dynamicConfigOptions.http = {
    services.navidrome.loadBalancer.servers = [
      {
        url = "http://localhost:4533";
      }
    ];

    routers.navidrome = {
      rule = "Host(`nd.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "navidrome";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/navidrome"];
    server.paths = ["/var/lib/navidrome"];
  };
}
