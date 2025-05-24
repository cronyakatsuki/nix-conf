{...}: {
  services.immich = {
    enable = true;
    port = 2283;
    host = "127.0.0.1";
    accelerationDevices = ["/dev/dri/renderD128"];
  };

  users.users.immich.extraGroups = ["video" "render"];

  services.traefik.dynamicConfigOptions.http = {
    services.immich.loadBalancer.servers = [
      {
        url = "http://localhost:2283";
      }
    ];

    routers.immich = {
      rule = "Host(`immich.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "immich";
      entrypoints = "websecure";
    };
  };
}
