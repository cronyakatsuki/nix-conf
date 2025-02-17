{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.nbfc.enable = lib.mkEnableOption "enable nbfc and set it up for my laptop";
  };

  config = lib.mkIf config.crony.nbfc.enable {
    # Install nbfc-linux
    environment.systemPackages = [
      inputs.nbfc-linux.packages.x86_64-linux.default
    ];

    # Setup nbfc package
    systemd.services.nbfc_service = {
      enable = true;
      description = "NoteBook FanControl Service";
      serviceConfig.Type = "simple";
      path = [pkgs.kmod];

      script = "${inputs.nbfc-linux.packages.x86_64-linux.default}/bin/nbfc_service --config-file '/home/crony/.config/nbfc.json'";

      wantedBy = ["multi-user.target"];
    };
  };
}
