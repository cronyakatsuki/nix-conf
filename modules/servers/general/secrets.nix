{
  age = {
    secrets = {
      traefik = {
        file = ../../../secrets/traefik.age;
        owner = "traefik";
      };
      crony-passwd = {
        file = ../../../secrets/crony-passwd-servers.age;
      };
      root-passwd = {
        file = ../../../secrets/root-passwd.age;
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
    };
  };
}
