{...}: {
  virtualisation.oci-containers.containers.website = {
    image = "docker.io/nginx:alpine";
    autoStart = true;
    ports = [
      "8001:80"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    volumes = [
      "/var/lib/website:/usr/share/nginx/html:ro"
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.website.loadBalancer.servers = [
      {
        url = "http://localhost:8001";
      }
    ];

    routers.website = {
      rule = "Host(`cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "website";
      entrypoints = "websecure";
    };
  };
}
