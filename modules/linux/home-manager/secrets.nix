{
  config,
  lib,
  ...
}: {
  options = {
    crony.home-secrets.enable = lib.mkEnableOption "Enable home-manager secrets.";
  };
  config = lib.mkIf config.crony.home-secrets.enable {
    age = {
      secrets = {
        restic-local-pass = {
          file = ../../../secrets/restic-local-pass.age;
        };
      };
      identityPaths = ["/home/crony/.ssh/main" "/root/.ssh/id_ed25519"];
    };
  };
}
