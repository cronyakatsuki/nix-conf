{config, ...}: {
  services.resolved.settings.Resolve = {
    DNSStubListener = "no";
  };

  networking = {
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "enp1s0";
      internalInterfaces = ["wg0"];
    };
    firewall = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53 51820];
    };
    wg-quick.interfaces.wg0.configFile = "${config.age.secrets.wg-heimdall.path}";
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "wg0";
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
