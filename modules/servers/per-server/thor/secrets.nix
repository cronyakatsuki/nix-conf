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
      lemmy-env = {
        file = "${inputs.secrets}/secrets/lemmy.env.age";
      };
    };
  };
}
