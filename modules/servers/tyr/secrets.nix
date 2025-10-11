{
  age = {
    secrets = {
      wg-tyr = {
        file = ../../../secrets/wg-tyr.age;
      };
      duckdns = {
        file = ../../../secrets/duckdns.age;
      };
      restic-server-local-pass = {
        file = ../../../secrets/restic-server-local-pass.age;
      };
      restic-server-pass = {
        file = ../../../secrets/restic-server-pass.age;
      };
      restic-server-repo = {
        file = ../../../secrets/restic-server-repo.age;
      };
      restic-server-env = {
        file = ../../../secrets/restic-server-env.age;
      };
      glance = {
        file = ../../../secrets/glance.age;
      };
      traefik = {
        file = ../../../secrets/traefik.age;
        owner = "traefik";
      };
    };
  };
}
