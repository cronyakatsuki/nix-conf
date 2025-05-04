{config, ...}: {
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      log = {level = "WARN";};
      certifiedResolvers = {
        porkbun = {
          acme = {
            email = "crony@cronyakatsuki.xyz";
            storage = "/var/lib/traefik/acme.json";
            caserver = "https://acme-v02.api.letsencrypt.org/directory";
            dnsChallenge = {
              provider = "porkbun";
              resolvers = ["1.1.1.1" "8.8.8.8"];
              propagation = {
                delayBeforeChecks = 60;
                disableChecks = true;
              };
            };
          };
        };
      };
      api = {};
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
        };
      };
    };
  };

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = ["${config.age.secrets.traefik.path}"];
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
