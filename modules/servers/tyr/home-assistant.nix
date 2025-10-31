{
  virtualisation.oci-containers.containers.homeassistant = {
    image = "homeassistant/home-assistant:stable";
    autoStart = true;
    ports = [
      "8123:8123"
    ];
    devices = [
      "/dev/ttyUSB0:/dev/ttyUSB0"
    ];
    privileged = true;
    capabilities = {
      NET_ADMIN = true;
      NET_RAW = true;
    };
    extraOptions = ["--network=host"];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/lib/homeassistant:/config"
      "/run/dbus:/run/dbus:ro"
    ];
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
