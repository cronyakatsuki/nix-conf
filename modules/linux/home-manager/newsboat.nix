{
  config,
  lib,
  ...
}: {
  options = {
    crony.newsboat.enable = lib.mkEnableOption "Enable and config newsboat how I wan't it";
  };

  config = lib.mkIf config.crony.newsboat.enable {
    programs.newsboat = {
      enable = true;
      autoReload = true;
      reloadThreads = 10;
      extraConfig = ''
        unbind-key ENTER
        unbind-key j
        unbind-key k
        unbind-key J
        unbind-key K

        bind-key j down
        bind-key k up
        bind-key l open
        bind-key h quit

        bind-key g home
        bind-key G end
        bind-key a toggle-article-read

        confirm-mark-feed-read yes

        urls-source "ttrss"
        ttrss-url "https://ttrss.cronyakatsuki.xyz"
        ttrss-login "crony"
        ttrss-passwordfile "~/.config/newsboat/password.txt"

        download-path "~/Downloads"
        max-downloads 2
        player "mpv"
      '';
    };
    home.file = {
      ".config/newsboat/urls".source = ./configs/newsboat-queries;
    };
  };
}
