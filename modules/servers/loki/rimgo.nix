{...}: {
  services.rimgo = {
    enable = true;
    settings = {
      PORT = 3000;
      ADDRESS = "127.0.0.1";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.rimgo.loadBalancer.servers = [
      {
        url = "http://localhost:3000";
      }
    ];

    routers.rimgo = {
      rule = "Host(`rimgo.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "rimgo";
      entrypoints = "websecure";
    };
  };
}
