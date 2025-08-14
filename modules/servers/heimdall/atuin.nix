{
  services.atuin = {
    enable = true;
    openRegistration = false;
  };

  services.traefik.dynamicConfigOptions.http = {
    services.atuin.loadBalancer.servers = [
      {
        url = "http://localhost:8888";
      }
    ];

    routers.atuin = {
      rule = "Host(`atuin.cronyakatsuki.xyz`)";
      tls = {
        certResolver = "porkbun";
      };
      service = "atuin";
      entrypoints = "websecure";
    };
  };
}
