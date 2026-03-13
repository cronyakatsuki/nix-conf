{inputs, ...}: {
  age = {
    secrets = {
      forgejo-runner-token = {
        file = "${inputs.secrets}/secrets/forgejo-runner-token.age";
      };
    };
  };
}
