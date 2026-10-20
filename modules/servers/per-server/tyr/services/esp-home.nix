{
  lib,
  pkgs,
  ...
}: {
  services.esphome.enable = true;

  # Upstream esphome 2026.8.0 removed the built-in `esphome dashboard`
  # subcommand, but nixpkgs' module still execs it (nixpkgs#563986),
  # so the service crash-loops. Run the official replacement dashboard
  # (ESPHome Device Builder) instead — same bind/port (localhost:6052)
  # and state dir, so the traefik routing below is unchanged.
  systemd.services.esphome.serviceConfig.ExecStart = lib.mkForce (
    "${lib.getExe pkgs.esphome-device-builder} /var/lib/esphome"
    + " --host localhost --port 6052"
    + " --trusted-domains esphome.home.cronyakatsuki.xyz"
  );

  services.traefik.dynamicConfigOptions.http = {
    services.esphome.loadBalancer.servers = [
      {
        url = "http://localhost:6052";
      }
    ];

    routers.esphome = {
      rule = "Host(`esphome.home.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "esphome";
      entrypoints = "websecure";
    };
  };
}
