{
  config,
  inputs,
  ...
}: {
  age = {
    secrets = {
      wg-tyr = {
        file = "${inputs.secrets}/secrets/wg-tyr.age";
      };
      duckdns = {
        file = "${inputs.secrets}/secrets/duckdns.age";
      };
      restic-server-local-pass = {
        file = "${inputs.secrets}/secrets/restic-server-local-pass.age";
      };
      restic-server-pass = {
        file = "${inputs.secrets}/secrets/restic-server-pass.age";
      };
      restic-server-repo = {
        file = "${inputs.secrets}/secrets/restic-server-repo.age";
      };
      restic-server-env = {
        file = "${inputs.secrets}/secrets/restic-server-env.age";
      };
      glance = {
        file = "${inputs.secrets}/secrets/glance.age";
      };
      traefik = {
        file = "${inputs.secrets}/secrets/traefik.age";
        owner = "traefik";
      };
      linkwarden = {
        file = "${inputs.secrets}/secrets/linkwarden.age";
        owner = config.services.linkwarden.user;
      };
      linkwarden-db = {
        file = "${inputs.secrets}/secrets/linkwarden.age";
      };
      paperless-ngx = {
        file = "${inputs.secrets}/secrets/paperless-ngx.age";
      };
      oink-apikey = {
        file = "${inputs.secrets}/secrets/oink-apikey.age";
      };
      oink-secret-apikey = {
        file = "${inputs.secrets}/secrets/oink-secret-apikey.age";
      };
      newt-env = {
        file = "${inputs.secrets}/secrets/newt.env.age";
      };
    };
  };
}
