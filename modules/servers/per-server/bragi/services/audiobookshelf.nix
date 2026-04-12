{...}: {
  services.audiobookshelf = {
    enable = true;
  };

  systemd.services.audiobookshelf = {
    after = ["mnt.mount"];
    bindsTo = ["mnt.mount"];
    requires = ["mnt.mount"];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.audiobookshelf.loadBalancer.servers = [
      {
        url = "http://localhost:8000";
      }
    ];

    routers.audiobookshelf = {
      rule = "Host(`abs.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "audiobookshelf";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/audiobookshelf"];
    server.paths = ["/var/lib/audiobookshelf"];
  };
}
