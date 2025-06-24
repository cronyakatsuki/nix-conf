{...}: {
  virtualisation.oci-containers.containers.crafty-controller = {
    image = "registry.gitlab.com/crafty-controller/crafty-4:latest";
    autoStart = true;
    ports = [
      "8443:8443"
      "8123:8123"
      "19132:19132"
      "25500-25600:25500-25600"
    ];
    volumes = [
      "/var/lib/crafty-controller/backups:/crafty/backups"
      "/var/lib/crafty-controller/logs:/crafty/logs"
      "/var/lib/crafty-controller/servers:/crafty/servers"
      "/var/lib/crafty-controller/config:/crafty/app/config"
      "/var/lib/crafty-controller/import:/crafty/import"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [25500];
    allowedUDPPorts = [25500];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.crafty.loadBalancer.servers = [
      {
        url = "https://localhost:8443";
      }
    ];

    routers.crafty = {
      rule = "Host(`crafty.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "crafty";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/crafty-controller"];
    server.paths = ["/var/lib/crafty-controller"];
  };
}
