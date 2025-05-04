{
  config,
  lib,
  ...
}: {
  options = {
    crony.wireguard.enable = lib.mkEnableOption "Open ports in firewall for wireguard to work.";
  };

  config = lib.mkIf config.crony.wireguard.enable {
    # Setup wireguard
    networking.wg-quick.interfaces.wg0 = {
      autostart = false;
      configFile = "${config.age.secrets.wg-desktop.path}";
    };
  };
}
