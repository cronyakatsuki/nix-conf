{
  heimdall = {
    type = "server";
    arch = "x86_64-linux";
  };
  bragi = {
    type = "server";
    arch = "aarch64-linux";
  };
  thor = {
    type = "server";
    arch = "aarch64-linux";
  };
  odin = {
    type = "server";
    arch = "aarch64-linux";
  };
  freyja = {
    type = "server";
    arch = "aarch64-linux";
  };
  tyr = {
    type = "server";
    arch = "x86_64-linux";
    # extraModules = [./modules/servers/tyr];
  };
  ymir = {
    type = "client";
    arch = "x86_64-linux";
    extraModules = [./modules/linux/nixos];
  };
  skadi = {
    type = "client";
    arch = "x86_64-linux";
    extraModules = [./modules/linux/nixos];
  };
}
