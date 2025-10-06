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
      loadModels = ["deepseek-r1:14b" "deepseek-coder-v2:16b-lite-instruct-q4_K_M"];
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
