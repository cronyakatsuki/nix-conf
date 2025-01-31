{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    crony.nbfc.enable = lib.mkEnableOption "enable nbfc and set it up for my laptop";
  };

  config = lib.mkIf config.crony.nbfc.enable {
    # Install nbfc-linux
    environment.systemPackages = with pkgs; [
      nbfc-linux
    ];

    # Setup nbfc package
    systemd.services.nbfc_service = {
      enable = false;
      description = "NoteBook FanControl Service";
      serviceConfig.Type = "simple";
      path = [pkgs.kmod];

      script = "${pkgs.nbfc-linux}/bin/nbfc_service --config-file '/home/crony/.config/nbfc.json'";

      wantedBy = ["multi-user.target"];
    };
  };
}
