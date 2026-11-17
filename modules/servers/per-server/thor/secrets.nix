{inputs, ...}: {
  age = {
    secrets = {
      forgejo-db = {
        file = "${inputs.secrets}/secrets/forgejo-db.age";
      };
      plausible = {
        file = "${inputs.secrets}/secrets/plausible.age";
      };
      conduit = {
        file = "${inputs.secrets}/secrets/conduit.age";
      };
      tuwunel = {
        file = "${inputs.secrets}/secrets/tuwunel.age";
        owner = "tuwunel";
        group = "tuwunel";
      };
      attic-thor-config = {
        file = "${inputs.secrets}/secrets/attic-thor-config.age";
        path = "/root/.config/attic/config.toml";
      };
    };
  };
}
