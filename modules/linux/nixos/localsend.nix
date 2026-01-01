{
  config,
  lib,
  ...
}: {
  options = {
    crony.localsend.enable = lib.mkEnableOption "Enable and setup localsend";
  };

  config = lib.mkIf config.crony.localsend.enable {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
