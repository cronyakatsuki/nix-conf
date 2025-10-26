{
  virtualisation.oci-containers.containers.homeassistant = {
    image = "homeassistant/home-assistant:stable";
    autoStart = true;
    ports = [
      "8123:8123"
    ];
    capabilities = {
      NET_ADMIN = true;
      NET_RAW = true;
    };
    volumes = [
      "/var/lib/homeassistant:/config"
      "/run/dbus:/run/dbus:ro"
    ];
    environment = {
      TZ = "Europe/Berlin";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/homeassistant"];
    server.paths = ["/var/lib/homeassistant"];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.assistant.loadBalancer.servers = [
      {
        url = "http://localhost:8123";
      }
    ];

    routers.assistant = {
      rule = "Host(`assistant.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "assistant";
      entrypoints = "websecure";
    };
  };
}
