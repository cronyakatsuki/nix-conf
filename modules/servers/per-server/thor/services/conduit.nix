{config, ...}: {
  services.matrix-tuwunel = {
    enable = true;
    settings.global = {
      server_name = "cronyakatsuki.xyz";
      allow_registration = true;
      registration_token_file = config.age.secrets.tuwunel.path;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.tuwunel.loadBalancer.servers = [
      {
        url = "http://localhost:6167";
      }
    ];

    routers.tuwunel = {
      rule = "Host(`matrix.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "tuwunel";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/matrix-tuwunel"];
    server.paths = ["/var/lib/matrix-tuwunel"];
  };
}
