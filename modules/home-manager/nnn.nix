{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    crony.nnn.enable = lib.mkEnableOption "Enable nnn and customize it for me.";
  };

  config = lib.mkIf config.crony.nnn.enable {
    # Needed enviromental variables
    home.sessionVariables = {
      NNN_FIFO = "/tmp/nnn.fifo";
    };
    # NNN Settings
    programs.nnn = {
      enable = true;
      package = pkgs.nnn.override {withNerdIcons = true;};
      bookmarks = {
        d = "~/Documents";
        D = "~/Downloads";
        p = "~/Pictures";
        v = "~/Videos";
      };
      extraPackages = with pkgs; [
        pmount
        ffmpegthumbnailer
        mediainfo
        ueberzugpp
        poppler_utils
        gnome-epub-thumbnailer
        nsxiv
      ];
      plugins.mappings = {
        u = "nmount";
        c = "chksum";
        r = "gitroot";
        v = "imgview";
        m = "mtpmount";
        d = "xdgdefault";
        x = "togglex";
        p = "preview-tui";
      };
      plugins.src =
        (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "62c84dd2549770e15c70328863a63da4fd2da2f9";
          hash = "sha256-Q/p4+v0sthcsmi8/EoAVT4dNl+hZNKZM4fjhffMpato=";
        })
        + "/plugins";
    };
  };
}
