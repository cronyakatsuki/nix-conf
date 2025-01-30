{
  config,
  lib,
  ...
}: {
  options = {
    crony.zsh.enable = lib.mkEnableOption "Enable zsh and customize it.";
  };

  config = lib.mkIf config.crony.zsh.enable {
    # Setup zsh
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;

      dotDir = ".config/zsh";

      initExtra = ''
        # VI Mode escape timeout fix
        export KEYTIMEOUT=1

        # Substring search settings
        export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=blue,fg=black,bold"
        export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black,bold'
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
      '';

      zplug = {
        enable = true;
        plugins = [
          {name = "zap-zsh/supercharge";}
          {name = "zap-zsh/completions";}
          {name = "zap-zsh/vim";}
          {name = "chivalryq/git-alias";}
          {name = "zdharma-continuum/fast-syntax-highlighting";}
          {name = "zsh-users/zsh-history-substring-search";}
          {name = "MichaelAquilina/zsh-you-should-use";}
        ];
      };
    };
  };
}
