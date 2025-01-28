{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  # Some info
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  # PACKAGES
  home.packages = with pkgs; [
    librewolf
    thunderbird
    qbittorrent
    alejandra
    keepassxc
    restic
    age
  ];

  # Enable programs to get their themes
  programs.foot.enable = true;
  programs.mangohud = {
    enable = true;
    settings = {
      fps_limit = "0,30,60,120,144";
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_power = true;
      gpu_text = "GPU";
      gpu_load_change = true;

      cpu_stats = true;
      cpu_temps = true;
      cpu_text = "CPU";
      cpu_mhz = true;
      cpu_load_change = true;

      vram = true;
      ram = true;

      fps = true;
      fps_sampling_period = "1000";
      fps_color_change = true;
      gpu_name = true;
      vulka_driver = true;
      round_corder = "10";
      offset_x = "10";
      offset_y = "10";

      width = "250";
    };
  };

  # Enable theming chromium + use ungoogled chromium package
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };

  # Enable git
  programs.git = {
    enable = true;
    userName = "Crony Akatsuki";
    userEmail = "crony@cronyakatsuki.xyz";
  };

  # Setup neovim
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        # Enable the aliases, I love them
        viAlias = true;
        vimAlias = true;

        # Changing some basic settings
        options = {
          tabstop = 2;
          shiftwidth = 2;
          updatetime = 50;
        };

        # Enable the undo file
        undoFile = {
          enable = true;
        };

        binds = {
          # Setup whichkey
          whichKey.enable = true;
        };

        # Enable gitsings
        git.gitsigns = {
          enable = true;
        };

        # Enable lsp
        lsp = {
          enable = true;
          lspkind.enable = true;
        };

        # Setup the theme
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        # Setup lsp's and languages
        languages = {
          enableLSP = true;
          enableTreesitter = true;
          enableFormat = true;

          nix = {
            enable = true;
          };
          bash.enable = true;
          go.enable = true;
          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };
        };

        # Enable mini modules ( mini is amazing )
        mini = {
          statusline.enable = true;
          comment.enable = true;
          notify.enable = true;
          surround.enable = true;
          diff.enable = true;
          pairs.enable = true;
          indentscope.enable = true;
          bufremove.enable = true;
          git.enable = true;
        };

        # Use telescope
        telescope.enable = true;

        # Enable autocompletion
        autocomplete.nvim-cmp = {
          enable = true;

          mappings = {
            close = null;
            complete = null;
            confirm = "<C-l>";
            next = "<C-j>";
            previous = "<C-k>";
          };
        };
      };
    };
  };

  # Enable syncthing
  services.syncthing.enable = true;

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

  # Install fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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
    icons = true;
  };

  # Install direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Default environmental variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Fix gtkrc-2.0 collision
  home.file."/home/crony/.gtkrc-2.0".force = true;

  # DO NOT CHANGE ALSO
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
