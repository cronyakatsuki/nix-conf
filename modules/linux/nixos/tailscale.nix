{
  config,
  lib,
  ...
}: {
  options = {
    crony.tailscale.enable = lib.mkEnableOption "Enable tailscale";
  };

  config = lib.mkIf config.crony.tailscale.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };
}
