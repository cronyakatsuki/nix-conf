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
    };
  };
}
