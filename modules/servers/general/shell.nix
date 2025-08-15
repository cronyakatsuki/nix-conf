{pkgs, ...}: {
  users.extraUsers.root = {
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    # historySubstringSearch.enable = true;

    shellAliases = {
      # General aliases
      grep = "grep --color=auto";
      cp = "cp -iv";
      rm = "rm -iv";
      mkd = "mkdir -pv";
      less = "less -R";
      df = "df -h -x devtmpfs -x tmpfs -x usbfs -x loop";
      free = "free -mht";
      # nnn on crack
      nnn = ''LC_COLLATE="C" nnn -xeaiH'';
      # Buku powerup
      b = "buku -p";
      # fzf shenanigans
      vif = ''nvim $(fzf --preview="bat --color=always {}")'';
    };

    # antidote = {
    #   enable = true;
    #   plugins = [
    #     "zap-zsh/supercharge"
    #     "zap-zsh/completions"
    #     "zap-zsh/vim"
    #     "chivalryq/git-alias"
    #     "zdharma-continuum/fast-syntax-highlighting"
    #     "zsh-users/zsh-history-substring-search"
    #     "MichaelAquilina/zsh-you-should-use"
    #   ];
    # };
  };
}
