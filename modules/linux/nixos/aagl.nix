{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.aagl-gtk-on-nix.nixosModules.default
  ];

  options = {
    crony.aagl.enable = lib.mkEnableOption "Enable aagl.";
  };

  config = lib.mkIf config.crony.aagl.enable {
    nix.settings = inputs.aagl-gtk-on-nix.nixConfig;

    programs.anime-game-launcher.enable = true;
  };
}
