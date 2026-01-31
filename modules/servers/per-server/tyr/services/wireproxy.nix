{pkgs, ...}: {
  systemd.services.wireproxy = {
    enable = true;
    description = "Wireproxy";
    after = ["network.target"];
    wants = ["network.target"];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 3;
      User = "wireproxy";
      Group = "wireproxy";
      WorkingDirectory = "/var/lib/wireproxy";
      StateDirectory = "wireproxy";
    };

    script = "${pkgs.wireproxy}/bin/wireproxy";

    wantedBy = ["multi-user.target"];
  };

  users = {
    users.wireproxy = {
      isSystemUser = true;
      home = "/var/lib/wireproxy";
      createHome = true;
      group = "wireproxy";
    };
    groups.wireproxy = {};
  };

  networking.firewall.allowedTCPPorts = [25344];
}
