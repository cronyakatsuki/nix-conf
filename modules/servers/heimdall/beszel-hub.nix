{pkgs, ...}: {
  systemd.services.beszel-hub = {
    enable = true;
    description = "Beszel agent";
    after = ["network.target"];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 3;
      User = "beszel";
      Group = "beszel";
      WorkingDirectory = "/var/lib/beszel";
    };

    script = "${pkgs.beszel}/bin/beszel-hub serve --http '127.0.0.1:6789'";

    wantedBy = ["multi-user.target"];
  };

  users = {
    users.beszel = {
      isSystemUser = true;
      home = "/var/lib/beszel";
      createHome = true;
      group = "beszel";
    };
    groups.beszel = {};
  };

  services.traefik.dynamicConfigOptions.http = {
    services.beszel.loadBalancer.servers = [
      {
        url = "http://localhost:6789";
      }
    ];

    routers.beszel = {
      rule = "Host(`beszel.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "beszel";
      entrypoints = "websecure";
    };
  };
}
