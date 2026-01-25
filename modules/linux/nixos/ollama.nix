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
      environmentVariables = {OLLAMA_KEEP_ALIVE = "2m";};
    };
  };
}
