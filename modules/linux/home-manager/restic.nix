{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.restic.enable = lib.mkEnableOption "Install and setup restic and backup services.";
  };

  config = lib.mkIf config.crony.restic.enable {
    # Install restic package
    home.packages = with pkgs; [
      restic
    ];

    ##-- Restic Timers And Services --##

    # Restic backup
    systemd.user.services = {
      restic_backup = {
        Unit.Description = "Restic backup service";
        Service = {
          Type = "oneshot";
          ExecStart = toString (pkgs.writeShellScript "restic-backup" ''
            . /etc/restic/local
            restic backup --files-from /home/crony/.config/restic/list --verbose && restic forget --keep-last 10 --keep-daily 7 --keep-weekly 5 --keep-monthly 12
            . /etc/restic/online
            restic backup --files-from /home/crony/.config/restic/list --verbose && restic forget --keep-last 10 --keep-daily 7 --keep-weekly 5 --keep-monthly 12
            rsync -avP --delete "$HOME/.local/backup/" "$HOME/Documents/Share/backup"
          '');
        };
      };
    };
    systemd.user.timers = {
      restic_backup = {
        Unit.Description = "Restic backup timer";
        Timer = {
          OnBootSec = "5m";
          OnUnitActiveSec = "6h";
        };
        Install.WantedBy = ["timers.target"];
      };
    };

    # Restic check
    systemd.user.services = {
      restic_check = {
        Unit.Description = "Restic check service";
        Service = {
          Type = "oneshot";
          ExecStart = toString (pkgs.writeShellScript "restic-check" ''
            . /etc/restic/local
            restic check --read-data-subset=10%
            . /etc/restic/online
            restic check --read-data-subset=10%
          '');
        };
      };
    };
    systemd.user.timers = {
      restic_check = {
        Unit.Description = "Restic check timer";
        Timer = {OnCalendar = "Thu *-*-* 18:00:00";};
        Install.WantedBy = ["timers.target"];
      };
    };

    # Restic prune
    systemd.user.services = {
      restic_prune = {
        Unit.Description = "Restic prune service";
        Service = {
          Type = "oneshot";
          ExecStart = toString (pkgs.writeShellScript "restic-prune" ''
            . /etc/restic/local
            restic prune
            . /etc/restic/online
            restic prune
          '');
        };
      };
    };
    systemd.user.timers = {
      restic_prune = {
        Unit.Description = "Restic prune timer";
        Timer = {OnCalendar = "Fri *-*-* 18:00:00";};
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
