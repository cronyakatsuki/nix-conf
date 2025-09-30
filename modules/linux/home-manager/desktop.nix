{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.desktop.enable = lib.mkEnableOption "Settings for setting up my desktop linux (mostly just my apps)";
  };

  config = lib.mkIf config.crony.desktop.enable {
    home.packages = with pkgs; [
      keepassxc
      vesktop
      piper
      galaxy-buds-client
      nicotine-plus
      ventoy
    ];

    # Install thunderbird
    programs.thunderbird = {
      enable = true;
      profiles.default.isDefault = true;
    };

    # Install imv
    programs.imv.enable = true;
  };
}
