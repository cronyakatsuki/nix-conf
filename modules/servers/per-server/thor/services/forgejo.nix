{config, ...}: {
  services.forgejo = {
    enable = true;
    settings = {
      session = {
        COOKIE_SECURE = true;
      };
      service = {
        REGISTER_MANUAL_CONFIRM = true;
        ENABLE_CAPTCHA = true;
        REQUIRE_CAPTCHA_FOR_LOGIN = true;
      };
      server = {
        ROOT_URL = "https://git.cronyakatsuki.xyz";
        HTTP_ADDR = "127.0.0.1";
      };
    };
    database = {
      passwordFile = "${config.age.secrets.forgejo-db.path}";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.forgejo.loadBalancer.servers = [
      {
        url = "http://localhost:3000";
      }
    ];

    routers.forgejo = {
      rule = "Host(`git.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "forgejo";
      entrypoints = "websecure";
    };
  };

  services.openssh = {
    authorizedKeysFiles = ["/var/lib/%u/.ssh/authorized_keys"];
    settings = {
      AllowUsers = ["forgejo"];
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/forgejo"];
    server.paths = ["/var/lib/forgejo"];
  };
}
