{
  services.nfs.server = {
    enable = true;
    exports = ''
      /export/nfs     192.168.0.0/24(rw,sync,no_subtree_check) 172.16.0.0/24(rw,sync,no_subtree_check)
    '';
  };
  networking.firewall.allowedTCPPorts = [2049];
}
