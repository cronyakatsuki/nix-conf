{
  config,
  lib,
  ...
}: {
  options = {
    crony.ollama.enable = lib.mkEnableOption "Enable and setup ollama";
  };

  config = lib.mkIf config.crony.ollama.enable {
    services.ollama = {
      enable = true;
      loadModels = ["llama3.2:3b" "deepseek-r1:1.5b"];
      acceleration = "cuda";
    };
    services.open-webui = {
      enable = true;
    };

    systemd.services.ollama.wantedBy = lib.mkForce [];
    systemd.services.ollama-model-loader.wantedBy = lib.mkForce [];
    systemd.services.open-webui.wantedBy = lib.mkForce [];
  };
}
