{...}: {
  services.audiobookshelf = {
    enable = true;
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
}
