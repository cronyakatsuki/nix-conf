{lib, ...}: {
  virtualisation.oci-containers.containers = {
    proxitok = {
      image = "ghcr.io/pablouser1/proxitok:master";
      autoStart = true;
      ports = [
        "8080:8080"
      ];
      networks = [
        "proxitok"
      ];
      hostname = "proxitok";
      environment = {
        LATTE_CACHE = "/cache";
        API_CACHE = "redis";
        REDIS_HOST = "proxitok-redis";
        REDIS_PORT = "6379";
        API_CHROMEDRIVER = "http://proxitok-chromedriver:9515";
        APP_URL = "https://proxytok.cronyakatsuki.xyz";
      };
      volumes = [
        "/var/lib/proxitok/cache:/cache"
      ];
      dependsOn = [
        "proxitok-redis"
        "proxitok-chromedriver"
      ];
    };
    proxitok-redis = {
      image = "docker.io/library/redis:7.4-alpine";
      autoStart = true;
      networks = [
        "proxitok"
      ];
      hostname = "proxitok-redis";
    };
    proxitok-chromedriver = {
      image = "docker.io/zenika/alpine-chrome:with-chromedriver";
      autoStart = true;
      networks = [
        "proxitok"
      ];
      hostname = "proxitok-chromedriver";
    };
  };

  system.activationScripts.createPodmanNetworkProxitok = lib.mkAfter ''
    if ! /run/current-system/sw/bin/podman network exists proxitok; then
      /run/current-system/sw/bin/podman network create proxitok
    fi
  '';

  services.traefik.dynamicConfigOptions.http = {
    services.proxitok.loadBalancer.servers = [
      {
        url = "https://localhost:8080";
      }
    ];

    routers.proxitok = {
      rule = "Host(`proxytok.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "proxitok";
      entrypoints = "websecure";
    };
  };
}
