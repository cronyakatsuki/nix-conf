{inputs, ...}: {
  age = {
    secrets = {
      searx = {
        file = "${inputs.secrets}/secrets/searx.age";
      };
      miniflux = {
        file = "${inputs.secrets}/secrets/miniflux.age";
      };
    };
  };
}
