{config, ...}: {
  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        server_name = "cronyakatsuki.xyz";
        database_backend = "rocksdb";
        allow_registration = true;
        allow_check_for_updates = true;
      };
    };
  };

  # systemd.services.conduit.serviceConfig = {
  #   EnvironmentFile = ["${config.age.secrets.conduit.path}"];
  # };
}
