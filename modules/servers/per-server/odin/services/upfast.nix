{
  inputs,
  pkgs,
  lib,
  ...
}: let
  upfast-cleaner = pkgs.writeShellApplication {
    name = "upfast-cleaner";
    runtimeInputs = with pkgs; [curl];
    text = ./upfast-cleaner.sh;
  };
in {
  fileSystems."/var/lib/upfast" = {
    device = "/root/10gb";
    fsType = "ext4";
    options = [
      "loop"
      "rw"
      "usrquota"
      "grpquota"
    ];
  };

  users = {
    users.upfast = {
      isSystemUser = true;
      home = "/var/lib/upfast";
      group = "upfast";
    };
    groups.upfast = {};
  };

  systemd.services.upfast = {
    enable = true;
    description = "SelfHosted file upload and share service like 0x0.st";
    serviceConfig = {
      Type = "simple";
      User = "upfast";
      Group = "upfast";
      WorkingDirectory = "/var/lib/upfast";
      Restart = "on-failure";
    };

    script = "${inputs.upfast.packages.aarch64-linux.default}/bin/upfast -p 8383 -d  https://upfast.cronyakatsuki.xyz";

    after = ["var-lib-upfast.mount"];
    bindsTo = ["var-lib-upfast.mount"];

    wantedBy = ["multi-user.target"];
  };

  systemd.services.upfast-cleaner = {
    description = "Script to automatically delete common types of payloads/keygens.";

    requires = ["upfast.service"];
    after = ["upfast.service"];

    serviceConfig = {
      Type = "oneshot";
      User = "upfast";
      Group = "upfast";
      WorkingDirectory = "/var/lib/upfast";
    };

    script = "${lib.getExe upfast-cleaner}";
  };

  systemd.timers.upfast-cleaner = {
    enable = true;
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
    };
    wantedBy = ["timers.target"];
  };

  services.traefik.dynamicConfigOptions.http = {
    services.upfast.loadBalancer.servers = [
      {
        url = "http://localhost:8383";
      }
    ];

    routers.upfast = {
      rule = "Host(`upfast.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "upfast";
      entrypoints = "websecure";
    };
  };

  services.restic.backups = {
    local.paths = ["/var/lib/upfast"];
    server.paths = ["/var/lib/upfast"];
  };
}
