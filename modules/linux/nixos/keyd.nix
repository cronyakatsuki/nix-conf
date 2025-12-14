{
  config,
  lib,
  ...
}: {
  options = {
    crony.keyd.enable = lib.mkEnableOption "Enable and setup keyd layers";
  };

  config = lib.mkIf config.crony.keyd.enable {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "overload(control, esc)";
            esc = "toggle(gaming)";
          };
          gaming = {
            capslock = "esc";
            rightshift = "rightshift";
          };
        };
      };
    };
  };
}
