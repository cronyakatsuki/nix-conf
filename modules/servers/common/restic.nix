{config, ...}: let
  opts = {
    paths = [
      "/var/lib/private"
    ];
    pruneOpts = [
      "--keep-last 10"
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
    ];
    pruneOptsLocal = [
      "--keep-last 2"
    ];
    checkOpts = [
      "--read-data-subset=10%"
      "--with-cache"
    ];
  };
in {
  services.restic.backups = {
    local = {
      initialize = true;
      passwordFile = config.age.secrets.restic-server-local-pass.path;
      repository = "/var/lib/backup";
      paths = opts.paths;
      pruneOpts = opts.pruneOptsLocal;
      checkOpts = opts.checkOpts;
    };
    server = {
      initialize = true;
      passwordFile = config.age.secrets.restic-server-pass.path;
      repositoryFile = config.age.secrets.restic-server-repo.path;
      environmentFile = config.age.secrets.restic-server-env.path;
      paths = opts.paths;
      pruneOpts = opts.pruneOpts;
      checkOpts = opts.checkOpts;
    };
  };
}
