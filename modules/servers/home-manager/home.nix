{
  config,
  pkgs,
  ...
}: {
  # Setup zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;

    dotDir = "${config.home.homeDirectory}/.config/zsh";

    shellAliases = {
      # General aliases
      cp = "cp -iv";
      rm = "rm -iv";
      mkd = "mkdir -pv";
      less = "less -R";
      df = "df -h -x devtmpfs -x tmpfs -x usbfs -x loop";
      free = "free -mht";
    };

    antidote = {
      enable = true;
      useFriendlyNames = true;
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

    initContent = ''
      ${pkgs.nerdfetch}/bin/nerdfetch
      # VI Mode escape timeout fix
      export KEYTIMEOUT=1

      # Substring search settings
      export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=blue,fg=black,bold"
      export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black,bold'
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down
    '';
  };

  home.packages = with pkgs; [
    unzip
    p7zip
    aria2
  ];

  # Install fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
  };

  # Install starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
    };
  };

  # Install zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Install eza
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "always";
  };

  # Install tealdeer
  programs.tealdeer.enable = true;

  # Install fd
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = ["~/Documents/Share" ".git"];
  };

  # Install btop
  programs.btop.enable = true;

  # Let home manager install and manage itself
  programs.home-manager.enable = true;

  # Install and setup atuin
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://atuin.cronyakatsuki.xyz";
      style = "compact";
      workspaces = true;
      keymap_mode = "vim-normal";
    };
  };
  # DO NOT CHANGE
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
