{
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

      blocking = {
        denylists = {
          "pro" = ["https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/pro.txt"];
          "tif" = ["https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/wildcard/tif.txt"];
        };
        clientGroupsBlock.default = ["pro" "tif"];
      };

      caching = {
        prefetching = true;
        minTime = "1m";
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

        prefetch = true;
        cache-max-ttl = 60;
        cache-max-negative-ttl = 60;
        serve-original-ttl = true;
      };
    };
  };
}
