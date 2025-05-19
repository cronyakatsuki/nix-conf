{pkgs, ...}: {
  systemd.services.beszel-agent = {
    enable = true;
    description = "Beszel Agent";
    after = ["network.target"];
    wants = ["network.target"];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 3;
      User = "beszel";
      Group = "beszel";
      WorkingDirectory = "/var/lib/beszel";
      StateDirectory = "beszel-agent";

      KeyringMode = "private";
      LockPersonality = "yes";
      NoNewPrivileges = "yes";
      ProtectClock = "yes";
      ProtectHome = "read-only";
      ProtectHostname = "yes";
      ProtectKernelLogs = "yes";
      ProtectSystem = "strict";
      RemoveIPC = "yes";
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
    };

    script = "${pkgs.beszel}/bin/beszel-agent -listen '45876' --key 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+T3fFx+Sv8jBGr2gNUHfuwUCbGhj8Mr/h4pmkI2Zjn'";

    wantedBy = ["multi-user.target"];
  };

  users = {
    users.beszel = {
      isSystemUser = true;
      home = "/var/lib/beszel";
      createHome = true;
      group = "beszel";
    };
    groups.beszel = {};
  };

  networking.firewall.extraCommands = ''
    iptables -N beszel  # create a new chain named beszel
    iptables -A beszel --src 65.21.241.194 -j ACCEPT  # allow 65.21.241.194
    iptables -A beszel -j DROP  # drop everyone else
    iptables -I INPUT -m tcp -p tcp --dport 45876 -j beszel  # use chain beszel for packets coming to TCP port 45876
  '';
}
