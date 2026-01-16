{config, ...}: {
  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        server_name = "cronyakatsuki.xyz";
        database_backend = "rocksdb";
        allow_registration = true;
        allow_check_for_updates = true;
      };
    };
  };

  systemd.services.conduit.serviceConfig = {
    EnvironmentFile = ["${config.age.secrets.conduit.path}"];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.conduit.loadBalancer.servers = [
      {
        url = "http://localhost:6167";
      }
    ];

    routers.conduit = {
      rule = "Host(`matrix.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "conduit";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/matrix-conduit"];
    server.paths = ["/var/lib/matrix-conduit"];
  };
}
