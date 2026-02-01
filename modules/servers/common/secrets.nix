{inputs, ...}: {
  age = {
    secrets = {
      traefik = {
        file = "${inputs.secrets}/secrets/traefik.age";
        owner = "traefik";
      };
      crony-passwd = {
        file = "${inputs.secrets}/secrets/crony-passwd-servers.age";
      };
      root-passwd = {
        file = "${inputs.secrets}/secrets/root-passwd.age";
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
    };
  };
}
