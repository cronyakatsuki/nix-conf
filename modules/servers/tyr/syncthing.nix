{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
  };

  networking.firewall = {
    allowedTCPPorts = [8384];
  };

  services.restic.backups = {
    local.paths = ["/var/lib/syncthing"];
    server.paths = ["/var/lib/syncthing"];
  };
}
