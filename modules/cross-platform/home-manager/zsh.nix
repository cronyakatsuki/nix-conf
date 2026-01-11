{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.zsh.enable = lib.mkEnableOption "Enable zsh and customize it.";
  };

  imports = [
    ({lib, ...}: {
      programs.zsh.initContent = lib.mkBefore ''
        # Tmux autostart
        if [ -x "$(command -v tmux)" ] && [ -n "$DISPLAY" ] && [ -z "$TMUX" ]; then
          exec tmux new-session -A -s default >/dev/null 2>&1
        fi
      '';
    })
    ({...}: {
      programs.zsh.initContent = ''
        ${pkgs.fastfetch}/bin/fastfetch
        # VI Mode escape timeout fix
        export KEYTIMEOUT=1

        # Substring search settings
        export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=blue,fg=black,bold"
        export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black,bold'
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down

        [[ -f "$HOME/.config/zsh/functions.zsh" ]] && source "$HOME/.config/zsh/functions.zsh"
      '';
    })
  ];

  config = lib.mkIf config.crony.zsh.enable {
    # Setup zsh
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;

      dotDir = "${config.home.homeDirectory}/.config/zsh";

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
        # fzf shenanigans
        vif = ''nvim $(fzf --preview="bat --color=always {}")'';
        emacs = "emacs --init-dir ~/.config/emacs";
      };

      antidote = {
        enable = true;
        plugins = [
          "zap-zsh/supercharge"
          "zap-zsh/completions"
          "zap-zsh/vim"
          "chivalryq/git-alias"
          "zdharma-continuum/fast-syntax-highlighting"
          "zsh-users/zsh-history-substring-search"
          "MichaelAquilina/zsh-you-should-use"
        ];
      };
    };
    # Link my functions file to ~/.config/zsh/functions.zsh
    home.file = {
      ".config/zsh/functions.zsh".source = ./configs/zsh-functions.zsh;
    };
  };
}
