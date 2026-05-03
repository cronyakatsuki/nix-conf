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
      piper
      galaxy-buds-client
      nicotine-plus
      feather
      gparted
      cameractrls-gtk4
      qbittorrent
      pavucontrol
      element-desktop
      bambu-studio
    ];

    # Install keepassxc
    programs.keepassxc.enable = true;

    # Install vesktop
    programs.vesktop.enable = true;

    # Install thunderbird
    programs.thunderbird = {
      enable = true;
      profiles.default.isDefault = true;
    };

    # Install imv
    programs.imv.enable = true;

    # Setup udisk for automatic mounting of usb devices
    services.udiskie = {
      enable = true;
      settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
          # replace with your favorite file manager
          file_manager = "${pkgs.kitty}/bin/kitty -e yazi";
        };
      };
    };
  };
}
