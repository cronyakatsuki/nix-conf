{
  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
    exports = ''
      /export/nfs     192.168.0.0/24(rw,sync,no_subtree_check) 172.16.0.0/24(rw,sync,no_subtree_check)
      /mnt/adata-hdd     192.168.0.0/24(rw,sync,no_subtree_check) 172.16.0.0/24(rw,sync,no_subtree_check)
    '';
  };
  networking.firewall.allowedTCPPorts = [111 2049 4000 4001 4002 20048];
  networking.firewall.allowedUDPPorts = [111 2049 4000 4001 4002 20048];

  # Mount external hdd
  fileSystems."/mnt/adata-hdd" = {
    device = "/dev/disk/by-uuid/2bb231c9-9f88-4cfc-bfc2-bc9b9d672387";
    fsType = "btrfs";
    options = [
      # "nofail"
      "exec"
      "compress=zstd:1"
    ];
  };
}
