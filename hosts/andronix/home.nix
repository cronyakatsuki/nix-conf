{
  pkgs,
  inputs,
  ...
}: {
  # Read the changelog before changing this value
  home.stateVersion = "24.05";

  # Packahes
  home.packages = with pkgs; [
    alejandra
  ];

  imports = [inputs.nvf.homeManagerModules.default];

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

      [[ -f "$HOME/.config/zsh/functions.zsh" ]] && source "$HOME/.config/zsh/functions.zsh"
    '';

    initExtraFirst = ''
      # Tmux autostart
      if [ -x "$(command -v tmux)" ] && [ -n "$DISPLAY" ] && [ -z "$TMUX" ]; then
        exec tmux new-session -A -s default >/dev/null 2>&1
      fi
    '';

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

  # Enable git
  programs.git = {
    enable = true;
    userName = "Crony Akatsuki";
    userEmail = "crony@cronyakatsuki.xyz";
  };

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

  # Install bat
  programs.bat.enable = true;

  # Install fd
  programs.fd.enable = true;

  # Install ripgrep
  programs.ripgrep.enable = true;

  # Install direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Install neovim
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      options = {
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        softtabstop = 2;
        updatetime = 50;
        scrolloff = 5;
        signcolumn = "no";
        ignorecase = true;
        smartcase = true;
        laststatus = 3;
      };

      undoFile.enable = true;

      lsp.enable = true;

      autocomplete.nvim-cmp.enable = true;

      languages = {
        enableLSP = true;
        enableTreesitter = true;
        enableFormat = true;

        nix.enable = true;
      };

      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };
    };
  };

  stylix = {
    enable = true;
    image = null;
    imageScalingMode = "fill";
    polarity = "dark";
    override = {};
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    autoEnable = false;
    cursor = null;
    fonts = rec {
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "Dejavu Sans";
      };
      serif = sansSerif;
      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "CommitMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        desktop = 10;
        terminal = 10;
        applications = 10;
      };
    };
  };
}
