{inputs, ...}: {
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
}
