{
  config,
  lib,
  ...
}: {
  imports = [
    ./librewolf.nix
  ];

  options = {
    crony.browsers.enable = lib.mkEnableOption "Enable my browsers and customize them";
  };

  config = lib.mkIf config.crony.browsers.enable {
    crony.browsers.librewolf.enable = lib.mkDefault true;
  };
}
