{config, ...}: {
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
    wg-quick.interfaces.wg0.configFile = "${config.age.secrets.wg-tyr.path}";
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
