{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.lnxlink.enable = lib.mkEnableOption "Enable and setup lnxlink.";
  };

  config = lib.mkIf config.crony.lnxlink.enable {
    home.packages = [
      inputs.lnxlink.packages.${pkgs.system}.default
    ];

    systemd.user.services.lnxlink = {
      Unit = {
        Description = "LNXLlink";
        After = ["network-online.target" "mutli-user.target" "graphical.target"];
        Requires = ["wireplumber.service"];
        PartOf = ["graphical-session.target"];
      };

      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        WorkingDirectory = "/home/crony/.config/lnxlink";
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        ExecStart = "${inputs.lnxlink.packages.${pkgs.system}.default}/bin/lnxlink --config /home/crony/.config/lnxlink/config.yaml";
      };
    };
  };
}
