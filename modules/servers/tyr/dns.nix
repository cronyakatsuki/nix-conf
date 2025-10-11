{config, ...}: {
  services.resolved.extraConfig = ''
    DNSStubListener=no
  '';

  # Setup blocky for adblocking
  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53;
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
          "pro" = ["https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/pro.txt"];
          "tif" = ["https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/tif.txt"];
          "fake" = ["https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/fake.txt"];
          "gambling" = ["https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/gambling.txt"];
        };
        clientGroupsBlock.default = ["pro" "tif" "fake" "gambling"];
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
          ''"glance.home.cronyakatsuki.xyz IN A 192.168.0.5"''
          ''"syncthing.home.cronyakatsuki.xyz IN A 192.168.0.5"''
          ''"wallos.home.cronyakatsuki.xyz IN A 192.168.0.5"''
        ];
      };
    };
  };

  # Setup duck dns for dynamic dns
  services.duckdns = {
    enable = true;
    domains = ["cronyakatsuki"];
    tokenFile = "${config.age.secrets.duckdns.path}";
  };
}
