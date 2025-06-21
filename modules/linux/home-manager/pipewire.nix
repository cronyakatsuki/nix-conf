{
  config,
  lib,
  ...
}: {
  options = {
    crony.pipewire.enable = lib.mkEnableOption "Setup some config files for my pipewire/wireplumber setup.";
  };

  config = lib.mkIf config.crony.pipewire.enable {
    home.file = {
      ".config/pipewire" = {source = ./configs/pipewire;};
    };
  };
}
