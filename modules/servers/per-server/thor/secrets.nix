{
  age = {
    secrets = {
      forgejo-db = {
        file = ../../../../secrets/forgejo-db.age;
      };
      plausible = {
        file = ../../../../secrets/plausible.age;
      };
      conduit = {
        file = ../../../../secrets/conduit.age;
      };
      lemmy-env = {
        file = ../../../../secrets/lemmy.env.age;
      };
    };
  };
}
