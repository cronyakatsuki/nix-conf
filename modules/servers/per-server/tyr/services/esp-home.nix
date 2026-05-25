{
  services.esphome.enable = true;

  services.traefik.dynamicConfigOptions.http = {
    services.esphome.loadBalancer.servers = [
      {
        url = "http://localhost:6052";
      }
    ];

    routers.esphome = {
      rule = "Host(`esphome.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "esphome";
      entrypoints = "websecure";
    };
  };
}
