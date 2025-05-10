{config, ...}: {
  services.plausible = {
    enable = true;
    server = {
      baseUrl = "https://plausible.cronyakatsuki.xyz";
      secretKeybaseFile = "${config.age.secrets.plausible.path}";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.plausible.loadBalancer.servers = [
      {
        url = "http://localhost:8000";
      }
    ];

    routers.plausible = {
      rule = "Host(`plausible.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "plausible";
      entrypoints = "websecure";
    };
  };
}
