{config, ...}: {
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      serversTransport.insecureSkipVerify = true;
      log = {level = "DEBUG";};
      experimental = {
        plugins = {
          fail2ban = {
            moduleName = "github.com/tomMoulard/fail2ban";
            version = "v0.8.7";
          };
        };
      };
      certificatesResolvers = {
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
          http.middlewares = [
            "fail2ban"
          ];
        };
      };
    };
    dynamicConfigOptions.http = {
      middlewares = {
        fail2ban = {
          plugin = {
            fail2ban = {
              rules = {
                bantime = "168h";
                enabled = true;
                findtime = "5m";
                maxretry = 50;
                statuscode = "400,401,403-499";
                urlregexps = [
                  {
                    regexp = "/*";
                    mode = "allow";
                  }
                ];
              };
              allowlist = {
                ip = ["65.21.241.194"];
              };
            };
          };
        };
      };
    };
  };

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = ["${config.age.secrets.traefik.path}"];
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
