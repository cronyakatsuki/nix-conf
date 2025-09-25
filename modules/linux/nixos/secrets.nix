{
  config,
  lib,
  ...
}: let
  default_keys = map (e: e.path) (
    lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys
  );
in {
  options = {
    crony.secrets.enable = lib.mkEnableOption "Enable desktop secrets.";
  };
  config = lib.mkIf config.crony.secrets.enable {
    age = {
      secrets = {
        wg-desktop = {
          file = ../../../secrets/wg-desktop.age;
        };
        wg-home = {
          file = ../../../secrets/wg-home.age;
        };
        wg-ymir-home = {
          file = ../../../secrets/wg-ymir-home.age;
        };
        crony-passwd = {
          file = ../../../secrets/crony-passwd-desktop.age;
        };
        root-passwd = {
          file = ../../../secrets/root-passwd.age;
        };
      };
      identityPaths = ["/home/crony/.ssh/main" "/root/.ssh/id_ed25519"] ++ default_keys;
    };
  };
}
