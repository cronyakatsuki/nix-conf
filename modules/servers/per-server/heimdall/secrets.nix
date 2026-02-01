{inputs, ...}: {
  age = {
    secrets = {
      wg-heimdall = {
        file = "${inputs.secrets}/secrets/wg-heimdall.age";
      };
    };
  };
}
