{...}: {
  virtualisation.oci-containers.containers.actualbudget = {
    image = "actualbudget/actual-server:latest";
    ports = ["5006:5006"];
    volumes = ["/var/lib/actual-budget:/data"];
    autoStart = true;
  };

  # Create the data directory on first boot
  system.activationScripts.actualbudget-dir = ''
    mkdir -p /var/lib/actual-budget
  '';

  networking.firewall.allowedTCPPorts = [5006];

  services.traefik.dynamicConfigOptions.http = {
    services.actual.loadBalancer.servers = [
      {
        url = "http://localhost:5006";
      }
    ];

    routers.actual = {
      rule = "Host(`actual.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "actual";
      entrypoints = "websecure";
    };
  };
}
