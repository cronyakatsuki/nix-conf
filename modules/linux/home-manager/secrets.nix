{
  config,
  lib,
  inputs,
  ...
}: {
  options = {
    crony.home-secrets.enable = lib.mkEnableOption "Enable home-manager secrets.";
  };
  config = lib.mkIf config.crony.home-secrets.enable {
    age = {
      secrets = {
        restic-local-pass = {
          file = "${inputs.secrets}/secrets/restic-local-pass.age";
        };
        restic-backblaze-pass = {
          file = "${inputs.secrets}/secrets/restic-backblaze-pass.age";
        };
        restic-backblaze-repo = {
          file = "${inputs.secrets}/secrets/restic-backblaze-repo.age";
        };
        restic-backblaze-env = {
          file = "${inputs.secrets}/secrets/restic-backblaze-env.age";
        };
      };
      identityPaths = ["/home/crony/.ssh/main" "/root/.ssh/id_ed25519"];
    };
  };
}
