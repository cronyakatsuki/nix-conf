{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  networking.hostName = "heimdall";

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.neovim
    pkgs.gitMinimal
  ];

  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0"; # either ens3 or enp1s0 depending on system, check 'ip addr'
    networkConfig.DHCP = "ipv4";
    address = [
      # replace this address with the one assigned to your instance
      "2a01:4f9:c010:c279::1/64"
    ];
    routes = [
      {Gateway = "fe80::1";}
    ];
  };

  system.stateVersion = "24.05";
}
