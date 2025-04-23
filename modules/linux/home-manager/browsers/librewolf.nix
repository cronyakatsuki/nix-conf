{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.browsers.librewolf.enable = lib.mkEnableOption "Enable librewolf and related options";
  };

  config = lib.mkIf config.crony.browsers.librewolf.enable {
    # Install librewolf
    programs.librewolf = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        tridactyl-native
        bukubrow
        keepassxc
      ];
    };

    # This tricks messaging hosts into working for no
    # real reason other than to make me rage at hour of debugging
    # (5 hours in total)
    programs.firefox = {
      package = pkgs.librewolf;
      enable = true;
      nativeMessagingHosts = with pkgs; [
        tridactyl-native
        bukubrow
        keepassxc
      ];
    };

    # disable stylix for librewolf and firefox
    stylix.targets = {
      firefox.enable = false;
      librewolf.enable = false;
    };
  };
}
