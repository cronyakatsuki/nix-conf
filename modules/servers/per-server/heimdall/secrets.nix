{inputs, ...}: {
  age = {
    secrets = {
      wg-heimdall = {
        file = "${inputs.secrets}/secrets/wg-heimdall.age";
      };
      attic-env = {
        file = "${inputs.secrets}/secrets/attic-env.age";
      };
    };
  };
}
