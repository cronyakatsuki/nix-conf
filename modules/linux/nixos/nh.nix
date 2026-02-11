{
  config,
  lib,
  ...
}: {
  options = {
    crony.nh.enable = lib.mkEnableOption "Enable nh and set it up for automatic cleaning.";
  };

  config = lib.mkIf config.crony.nh.enable {
    # Install nh
    programs.nh = {
      enable = true;
      flake = "/home/crony/repos/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep 20 --keep-since 1w --optimise";
        dates = "daily";
      };
    };
  };
}
