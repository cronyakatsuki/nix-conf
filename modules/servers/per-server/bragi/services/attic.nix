{config, ...}: {
  # imports = [inputs.attic.nixosModules.atticd];

  services.atticd = {
    enable = true;

    environmentFile = "${config.age.secrets.attic-env.path}";

    settings = {
      listen = "127.0.0.1:8484";

      api-endpoint = "https://cache.cronyakatsuki.xyz/";

      storage = {
        type = "s3";
        region = "us-east-005";
        bucket = "76302220-b368-4328-b566-2a038235b314--attic";
        endpoint = "s3.us-east-005.backblazeb2.com";
      };

      jwt = {};
      chunking = {
        nar-size-threshold = 64 * 1024; # 64 KiB
        min-size = 16 * 1024; # 16 KiB
        avg-size = 64 * 1024; # 64 KiB
        max-size = 256 * 1024; # 256 KiB
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    services.attic.loadBalancer.servers = [
      {
        url = "http://localhost:8484";
      }
    ];

    routers.attic = {
      rule = "Host(`cache.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "attic";
      entrypoints = "websecure";
    };
  };
}
