{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.scripts.enable = lib.mkEnableOption "Enable my custom scripts";
  };

  config = lib.mkIf config.crony.scripts.enable {
    home.packages = with pkgs; [
      (callPackage ./scripts {inherit pkgs;})
    ];
  };
}
