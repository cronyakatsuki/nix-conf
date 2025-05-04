{...}: {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.cronyakatsuki.xyz";
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;
      auth-default-access = "deny-all";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.ntfy-sh.loadBalancer.servers = [
      {
        url = "http://localhost:2586";
      }
    ];

    routers.ntfy-sh = {
      rule = "Host(`ntfy.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "ntfy-sh";
      entrypoints = "websecure";
    };
  };
}
