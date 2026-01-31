{config, ...}: {
  age = {
    secrets = {
      wg-tyr = {
        file = ../../../../secrets/wg-tyr.age;
      };
      duckdns = {
        file = ../../../../secrets/duckdns.age;
      };
      restic-server-local-pass = {
        file = ../../../../secrets/restic-server-local-pass.age;
      };
      restic-server-pass = {
        file = ../../../../secrets/restic-server-pass.age;
      };
      restic-server-repo = {
        file = ../../../../secrets/restic-server-repo.age;
      };
      restic-server-env = {
        file = ../../../../secrets/restic-server-env.age;
      };
      glance = {
        file = ../../../../secrets/glance.age;
      };
      traefik = {
        file = ../../../../secrets/traefik.age;
        owner = "traefik";
      };
      ddns = {
        file = ../../../../secrets/ddns.age;
        path = "/var/lib/ddns-updater/config.json";
        owner = "nobody";
        group = "nogroup";
        symlink = false;
      };
      linkwarden = {
        file = ../../../../secrets/linkwarden.age;
        owner = config.services.linkwarden.user;
      };
      linkwarden-db = {
        file = ../../../../secrets/linkwarden.age;
      };
      paperless-ngx = {
        file = ../../../../secrets/paperless-ngx.age;
      };
      wg-wireproxy = {
        file = ../../../../secrets/wg-wireproxy.age;
        owner = "wireproxy";
        group = "wireproxy";
      };
      wireproxy = {
        file = ../../../../secrets/wireproxy.age;
        path = "/etc/wireproxy/wireproxy.conf";
        owner = "wireproxy";
        group = "wireproxy";
        symlink = false;
      };
    };
  };
}
