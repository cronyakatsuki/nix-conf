{inputs, ...}: {
  age = {
    secrets = {
      rclone = {
        file = "${inputs.secrets}/secrets/rclone.age";
      };
      navidrome = {
        file = "${inputs.secrets}/secrets/navidrome.age";
      };
      attic-env = {
        file = "${inputs.secrets}/secrets/attic-env.age";
      };
    };
  };
}
