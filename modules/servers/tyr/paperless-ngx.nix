{config, ...}: {
  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets.paperless-ngx.path;
    domain = "paperless.home.cronyakatsuki.xyz";
    settings = {
      PAPERLESS_OCR_LANGUAGE = "hrv+eng";
      PAPERLESS_ADMIN_USER = "crony";
      PAPERLESS_URL = "https://paperless.home.cronyakatsuki.xyz";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.paperless.loadBalancer.servers = [
      {
        url = "http://localhost:28981";
      }
    ];

    routers.paperless = {
      rule = "Host(`paperless.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "paperless";
      entrypoints = "websecure";
    };
  };
}
