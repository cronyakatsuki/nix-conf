{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.ollama.enable = lib.mkEnableOption "Enable and setup ollama";
  };

  config = lib.mkIf config.crony.ollama.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      loadModels = ["gpt-oss:20b"];
    };
    # services.open-webui = {
    #   enable = true;
    # };

    systemd.services.ollama.wantedBy = lib.mkForce [];
    systemd.services.ollama-model-loader.wantedBy = lib.mkForce [];
    # systemd.services.open-webui.wantedBy = lib.mkForce [];
  };
}
