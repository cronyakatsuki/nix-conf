{
  config,
  lib,
  ...
}: {
  options = {
    crony.xdg-user-dirs.enable = lib.mkEnableOption "Manage user-dir.dirs with my settings";
  };

  config = lib.mkIf config.crony.xdg-user-dirs.enable {
    xdg.userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}/.local/share/desktop";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/downs";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pics";
      publicShare = "${config.home.homeDirectory}/.local/share/public";
      templates = "${config.home.homeDirectory}/.local/share/templates";
      videos = "${config.home.homeDirectory}/vids";
      createDirectories = true;
    };
  };
}
