{pkgs, ...}: {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [
          "--filter=until=24h"
          "--filter=label!=important"
        ];
      };
      defaultNetwork.settings.dns.enable = true;
    };
  };

  # Enable system podman autoupdate timer
  systemd.timers.podman-auto-update = {
    enable = true;
    wantedBy = ["timers.target"];
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
  ];
}
