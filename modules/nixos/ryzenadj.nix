{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.ryzenadj.enable = lib.mkEnableOption "Enable ryzenadj and customize it for my system.";
  };

  config = lib.mkIf config.crony.ryzenadj.enable {
    # Add ryzen-smu driver to allow reading values
    boot.extraModulePackages = with config.boot.kernelPackages; [ryzen-smu];

    # Install ryzenadj globally
    environment.systemPackages = with pkgs; [
      ryzenadj
    ];

    # Setup python service for ryzenadj
    systemd.services.ryzenadj = {
      enable = true;
      description = "Set my cpu power usage power to something more manageable.";
      serviceConfig.Type = "oneshot";
      wantedBy = ["multi-user.target"];
      script = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit 30000 --fast-limit 30000 --slow-limit 30000 --slow-time 60 --stapm-time 1000 --tctl-temp 85 --vrmmax-current 46000";
    };
  };
}
