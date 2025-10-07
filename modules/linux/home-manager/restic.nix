{
  config,
  pkgs,
  lib,
  ...
}: let
  opts = {
    paths = [
      "/home/crony/.face"
      # "/home/crony/.librewolf"
      "/home/crony/.ssh"
      "/home/crony/.config/heroic"
      # "/home/crony/.config/nbfc.json"
      # "/home/crony/.config/OpenTabletDriver"
      # "/home/crony/.config/tridactyl"
      "/home/crony/.local/share/gnupg"
      # "/home/crony/.local/share/osu"
      "/home/crony/docs/sync"
      "/home/crony/docs/wireguard-keys"
      "/home/crony/pics"
    ];
    pruneOpts = [
      "--keep-last 10"
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
    ];
    checkOpts = [
      "--read-data-subset=10%"
      "--with-cache"
    ];
  };
in {
  options = {
    crony.restic.enable = lib.mkEnableOption "Install and setup restic and backup services.";
  };

  config = lib.mkIf config.crony.restic.enable {
    # Install restic package
    home.packages = with pkgs; [
      restic
    ];

    # Restic home manager service
    services.restic = {
      enable = true;
      backups = {
        local = {
          initialize = true;
          passwordFile = "/run/user/1000/agenix/restic-local-pass";
          repository = "/home/crony/.local/backup";
          paths = opts.paths;
          pruneOpts = opts.pruneOpts;
          checkOpts = opts.checkOpts;
        };
        nas = {
          initialize = true;
          passwordFile = "/run/user/1000/agenix/restic-local-pass";
          repository = "/home/crony/docs/nfs/backup";
          paths = opts.paths;
          pruneOpts = opts.pruneOpts;
          checkOpts = opts.checkOpts;
        };
        backblaze = {
          initialize = true;
          passwordFile = "/run/user/1000/agenix/restic-backblaze-pass";
          repositoryFile = "/run/user/1000/agenix/restic-backblaze-repo";
          environmentFile = "/run/user/1000/agenix/restic-backblaze-env";
          paths = opts.paths;
          pruneOpts = opts.pruneOpts;
          checkOpts = opts.checkOpts;
        };
      };
    };
  };
}
