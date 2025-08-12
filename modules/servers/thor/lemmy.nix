{
  pkgs,
  lib,
  config,
  ...
}: {
  # Enable container name DNS for all Podman networks.
  networking.firewall.interfaces = let
    matchAll =
      if !config.networking.nftables.enable
      then "podman+"
      else "podman*";
  in {
    "${matchAll}".allowedUDPPorts = [53];
  };

  # Containers
  virtualisation.oci-containers.containers."lemmy-backend" = {
    image = "dessalines/lemmy:0.19.11";
    environmentFiles = [
      "/run/agenix/lemmy-env"
    ];
    volumes = [
      "/var/lib/lemmy/lemmy.hjson:/config/config.hjson:rw,Z"
    ];
    dependsOn = [
      "lemmy-db"
      "lemmy-pictrs"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=lemmy"
      "--network-alias=lemmy"
      "--network=lemmy_default"
    ];
  };
  systemd.services."podman-lemmy-backend" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-lemmy_default.service"
    ];
    requires = [
      "podman-network-lemmy_default.service"
    ];
    partOf = [
      "podman-compose-lemmy-root.target"
    ];
    wantedBy = [
      "podman-compose-lemmy-root.target"
    ];
  };
  virtualisation.oci-containers.containers."lemmy-db" = {
    image = "docker.io/postgres:16-alpine";
    environmentFiles = [
      "/run/agenix/lemmy-env"
    ];
    volumes = [
      "/var/lib/lemmy/volumes/postgres:/var/lib/postgresql/data:rw,Z"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=postgres-lemmy"
      "--network-alias=postgres"
      "--network=lemmy_default"
    ];
  };
  systemd.services."podman-lemmy-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-lemmy_default.service"
    ];
    requires = [
      "podman-network-lemmy_default.service"
    ];
    partOf = [
      "podman-compose-lemmy-root.target"
    ];
    wantedBy = [
      "podman-compose-lemmy-root.target"
    ];
  };
  virtualisation.oci-containers.containers."lemmy-pictrs" = {
    image = "docker.io/asonix/pictrs:0.5";
    environmentFiles = [
      "/run/agenix/lemmy-env"
    ];
    volumes = [
      "/var/lib/lemmy/volumes/pictrs:/mnt:rw,Z"
    ];
    user = "991:991";
    log-driver = "journald";
    extraOptions = [
      "--hostname=pictrs"
      "--memory=723517440b"
      "--network-alias=pictrs"
      "--network=lemmy_default"
    ];
  };
  systemd.services."podman-lemmy-pictrs" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-lemmy_default.service"
    ];
    requires = [
      "podman-network-lemmy_default.service"
    ];
    partOf = [
      "podman-compose-lemmy-root.target"
    ];
    wantedBy = [
      "podman-compose-lemmy-root.target"
    ];
  };
  virtualisation.oci-containers.containers."lemmy-proxy" = {
    image = "nginx:1-alpine";
    environmentFiles = [
      "/run/agenix/lemmy-env"
    ];
    volumes = [
      "/var/lib/lemmy/nginx_internal.conf:/etc/nginx/nginx.conf:ro,Z"
      "/var/lib/lemmy/proxy_params:/etc/nginx/proxy_params:ro,Z"
    ];
    ports = [
      "127.0.0.1:1236:8536/tcp"
    ];
    dependsOn = [
      "lemmy-pictrs"
      "lemmy-ui"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=proxy"
      "--network=lemmy_default"
    ];
  };
  systemd.services."podman-lemmy-proxy" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-lemmy_default.service"
    ];
    requires = [
      "podman-network-lemmy_default.service"
    ];
    partOf = [
      "podman-compose-lemmy-root.target"
    ];
    wantedBy = [
      "podman-compose-lemmy-root.target"
    ];
  };
  virtualisation.oci-containers.containers."lemmy-ui" = {
    image = "dessalines/lemmy-ui:0.19.11";
    environmentFiles = [
      "/run/agenix/lemmy-env"
    ];
    volumes = [
      "/var/lib/lemmy/volumes/lemmy-ui/extra_themes:/app/extra_themes:rw"
    ];
    dependsOn = [
      "lemmy-backend"
      "lemmy-pictrs"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=lemmy-ui"
      "--network=lemmy_default"
    ];
  };
  systemd.services."podman-lemmy-ui" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-lemmy_default.service"
    ];
    requires = [
      "podman-network-lemmy_default.service"
    ];
    partOf = [
      "podman-compose-lemmy-root.target"
    ];
    wantedBy = [
      "podman-compose-lemmy-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-lemmy_default" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f lemmy_default";
    };
    script = ''
      podman network inspect lemmy_default || podman network create lemmy_default
    '';
    partOf = ["podman-compose-lemmy-root.target"];
    wantedBy = ["podman-compose-lemmy-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-lemmy-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = ["multi-user.target"];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.lemmy.loadBalancer.servers = [
      {
        url = "http://localhost:1236";
      }
    ];

    routers.lemmy = {
      rule = "Host(`lemmy.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "lemmy";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/lemmy"];
    server.paths = ["/var/lib/lemmy"];
  };
}
