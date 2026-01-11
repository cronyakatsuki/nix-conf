{config, ...}: {
  services.linkwarden = {
    enable = true;
    secretFiles = {
      NEXTAUTH_SECRET = config.age.secrets.linkwarden.path;
      POSTGRES_PASSWORD = config.age.secrets.linkwarden-db.path;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.linkwarden.loadBalancer.servers = [
      {
        url = "http://localhost:3000";
      }
    ];

    routers.linkwarden = {
      rule = "Host(`linkwarden.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "linkwarden";
      entrypoints = "websecure";
    };
  };
}
