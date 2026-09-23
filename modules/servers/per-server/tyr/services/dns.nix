{
  config,
  pkgs,
  ...
}: {
  # Setup ssl cert for dot
  security.acme = {
    acceptTerms = true;
    defaults.email = "crony@cronyakatsuki.xyz";

    certs."dns.cronyakatsuki.xyz" = {
      dnsProvider = "porkbun";
      environmentFile = "/run/agenix/traefik";
      group = "blocky";
      reloadServices = ["blocky.service"];
    };
  };

  # Setup blocky for adblocking
  services.blocky = {
    enable = true;
    settings = {
      ports.tls = [
        "127.0.0.1:853"
        "192.168.0.5:853"
        "[::1]:853"
      ];
      certFile = "/var/lib/acme/dns.cronyakatsuki.xyz/fullchain.pem";
      keyFile = "/var/lib/acme/dns.cronyakatsuki.xyz/key.pem";

      rateLimit = {
        enable = true;
        rate = 50;
        burst = 100;
        ipv4Prefix = 32;
        ipv6Prefix = 64;
        allowlist = ["10.0.0.0/8" "192.168.0.0/16"];
      };

      rebindingProtection = {
        enable = true;
        allowedDomains = ["home.cronyakatsuki.xyz"];
      };

      ports.dns = [
        "127.0.0.1:53"
        "192.168.0.5:53"
        "[::1]:53"
      ];
      connectIPVersion = "v4";

      upstreams.groups.default = [
        "127.0.0.1:553"
      ];

      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = ["1.1.1.1" "1.0.0.1"];
      };

      blocking = {
        denylists = {
          "default" = [
            "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/pro.txt"
            "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/fake.txt"
            "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/popupads.txt"
            "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/tif.txt"
            "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/hoster.txt"
            "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/gambling.txt"
            "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/native.samsung.txt"
          ];
        };
        allowlists = {
          "default" = [
            ''
              jnn-pa.googleapis.com
              challenges.cloudflare.com
            ''
          ];
        };
        clientGroupsBlock.default = ["default"];
      };

      caching = {
        prefetching = true;
        minTime = "1m";
      };

      clientLookup = {
        upstream = "192.168.0.1";
        singleNameOrder = [1];
      };
    };
  };

  # Let LAN clients reach blocky on 192.168.0.5:53 (matching the bind addresses above).
  networking.firewall = {
    allowedUDPPorts = [53];
    allowedTCPPorts = [53 853];
  };

  # Setup unbound for recursive dns
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = ["127.0.0.1"];
        port = 553;
        do-ip4 = true;
        do-ip6 = false;
        access-control = ["127.0.0.1 allow"];
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        edns-buffer-size = 1232;

        hide-identity = true;
        hide-version = true;

        prefetch = true;
        cache-max-ttl = 60;
        cache-max-negative-ttl = 60;
        serve-original-ttl = true;

        local-zone = [''"home.cronyakatsuki.xyz." transparent''];

        local-data = [
          ''"syncthing.home.cronyakatsuki.xyz IN A 192.168.0.5"''
          ''"assistant.home.cronyakatsuki.xyz IN A 192.168.0.5"''
          ''"ddns.home.cronyakatsuki.xyz IN A 192.168.0.5"''
          ''"linkwarden.home.cronyakatsuki.xyz IN A 192.168.0.5"''
          ''"paperless.home.cronyakatsuki.xyz IN A 192.168.0.5"''
          ''"esphome.home.cronyakatsuki.xyz IN A 192.168.0.5"''
          ''"actual.home.cronyakatsuki.xyz IN A 192.168.0.5"''
        ];
      };
    };
  };

  services.oink = {
    enable = true;
    domains = [
      {
        domain = "cronyakatsuki.xyz";
        subdomain = "home";
      }
    ];
    apiKeyFile = "${config.age.secrets.oink-apikey.path}";
    secretApiKeyFile = "${config.age.secrets.oink-secret-apikey.path}";
  };

  systemd.services.oink = {
    after = ["blocky.service" "unbound.service"];
    requires = ["blocky.service" "unbound.service"];
    preStart = ''
      until ${pkgs.dig}/bin/dig +short +time=2 +tries=1 @127.0.0.1 example.com >/dev/null 2>&1; do
        echo "waiting for blocky DNS to resolve…";
        sleep 2;
      done
    '';
  };

  systemd.services.traefik = {
    after = ["blocky.service" "unbound.service"];
    requires = ["blocky.service" "unbound.service"];
    preStart = ''
      until ${pkgs.dig}/bin/dig +short +time=2 +tries=1 @127.0.0.1 example.com >/dev/null 2>&1; do
        echo "waiting for blocky DNS to resolve…";
        sleep 2;
      done
    '';
  };
}
