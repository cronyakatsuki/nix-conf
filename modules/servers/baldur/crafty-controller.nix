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
}
