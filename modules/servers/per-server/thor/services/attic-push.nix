{
  # Automatically push every path that enters thor's store to the attic cache
  # (covers everything the PC-dispatched remote builds produce)
  systemd.services.attic-watch-store = {
    description = "Push new Nix store paths to attic cache (server)";
    documentation = ["https://docs.attic.rs"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    path = [];

    environment.HOME = "/root";

    serviceConfig = {
      ExecStart = "${pkgs.attic-client}/bin/attic watch-store server";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  systemd.tmpfiles.rules = [
    "d /root/.config/attic 0700 root root -"
  ];
}
