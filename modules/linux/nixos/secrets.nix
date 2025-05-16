{
  age = {
    secrets = {
      wg-desktop = {
        file = ../../../secrets/wg-desktop.age;
      };
      crony-passwd = {
        file = ../../../secrets/crony-passwd-desktop.age;
      };
      root-passwd = {
        file = ../../../secrets/root-passwd.age;
      };
    };
    identityPaths = ["/home/crony/.ssh/main"];
  };
}
