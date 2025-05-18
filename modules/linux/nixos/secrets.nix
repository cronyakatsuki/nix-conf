{
  config,
  lib,
  ...
}: {
  options = {
    crony.secrets.enable = lib.mkEnableOption "Enable desktop secrets.";
  };
  config = lib.mkIf config.crony.secrets.enable {
    age = {
      secrets = {
        wg-desktop = {
          file = ../../../secrets/wg-desktop.age;
        };
        crony-passwd = {
          file = ../../../secrets/crony-passwd-desktop.age;
        };
        root-passwd = {
          file = ../../../secrets/root-passwd.age;
        };
      };
      identityPaths = ["/home/crony/.ssh/main" "/root/.ssh/id_ed25519"];
    };
  };
}
