{
  virtualisation.oci-containers.containers.wallos = {
    image = "bellamy/wallos:latest";
    autoStart = true;
    ports = [
      "8282:80/tcp"
    ];
    volumes = [
      "/var/lib/wallos/db:/var/www/html/db"
      "/var/lib/wallos/logos:/var/www/html/images/uploads/logos"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [8282];
  };
}
