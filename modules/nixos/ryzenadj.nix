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

      path = [pkgs.ryzenadj pkgs.python3];

      description = "Set my cpu power usage power to something more manageable.";
      serviceConfig.Type = "simple";
      script = "python ${./scripts/ryzenadj-service} --stapm-limit 30000 --fast-limit 30000 --slow-limit 30000 --slow-time 60 --stapm-time 1000 --tctl-temp 80 --vrmmax-current 50000";

      wantedBy = ["multi-user.target"];
    };
  };
}
