{
  lib,
  pkgs,
  inputs,
  ...
}: {
  home.username = "banir";
  home.homeDirectory = "/home/banir";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;

    dotDir = ".config/zsh";

    shellAliases = {
      # General aliases
      grep = "grep --color=auto";
      cp = "cp -iv";
      rm = "rm -iv";
      mkd = "mkdir -pv";
      less = "less -R";
      df = "df -h -x devtmpfs -x tmpfs -x usbfs -x loop";
      free = "free -mht";
      # fzf shenanigans
      vif = ''nvim $(fzf --preview="bat --color=always {}")'';
    };

    initExtra = ''
      ${pkgs.nerdfetch}/bin/nerdfetch
      # VI Mode escape timeout fix
      export KEYTIMEOUT=1

      # Substring search settings
      export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=blue,fg=black,bold"
      export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black,bold'
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down

      # Make sure to load home manager profile
      . "$HOME/.nix-profile/etc/profile.d/nix.sh"
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

  # Install direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Install the fuck
  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
  };

  # Install bat
  programs.bat.enable = true;

  # Install fd
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = ["~/Documents/Share" ".git"];
  };

  # Install rg
  programs.ripgrep = {
    enable = true;
  };

  # Install btop
  programs.btop.enable = true;

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
          expandtab = true;
          softtabstop = 2;
          updatetime = 50;
          scrolloff = 5;
          signcolumn = "no";
          ignorecase = true;
          smartcase = true;
          colorcolumn = "80";
          laststatus = 3;
        };

        # Enable the undo file
        undoFile = {
          enable = true;
        };

        binds = {
          # Setup whichkey
          whichKey.enable = true;
        };

        # Enable lsp
        lsp = {
          enable = true;
        };

        # Autocompletion
        autocomplete.nvim-cmp = {
          enable = true;
          mappings = {
            close = "<C-h>";
            complete = null;
            confirm = "<C-l>";
            next = "<C-j>";
            previous = "<C-k>";
          };
        };

        # Setup lsp's and languages
        languages = {
          enableLSP = true;
          enableTreesitter = true;
          enableFormat = true;

          lua = {
            enable = true;
            lsp.lazydev.enable = true;
          };
          python = {
            enable = true;
            format.type = "black-and-isort";
          };
          css.enable = true;
          ts.enable = true;
          bash.enable = true;
          markdown.enable = true;
          html.enable = true;
        };

        # Enable mini modules ( mini is amazing )
        mini = {
          # Text editing
          ai.enable = true;
          comment.enable = true;
          operators.enable = true;
          pairs.enable = true;
          surround.enable = true;
          basics = {
            enable = true;
            setupOpts = {
              mappings = {
                windows = true;
                move_with_alt = true;
              };
            };
          };
          bracketed.enable = true;
          bufremove.enable = true;
          diff.enable = true;
          files.enable = true;
          git.enable = true;
          hipatterns = {
            enable = true;
            setupOpts = {
              highlighters = {
                fixme = lib.generators.mkLuaInline "{ pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' }";
                hack = lib.generators.mkLuaInline "{ pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  }";
                todo = lib.generators.mkLuaInline "{ pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  }";
                note = lib.generators.mkLuaInline "{ pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  }";
                hex_color = lib.generators.mkLuaInline "require('mini.hipatterns').gen_highlighter.hex_color()";
              };
            };
          };
          icons.enable = true;
          indentscope.enable = true;
          notify.enable = true;
          statusline.enable = true;
          move.enable = true;
          splitjoin.enable = true;
        };

        # Use telescope
        telescope = {
          enable = true;
          setupOpts = {
            extensions = {
              fzf = {
                fuzzy = true;
                override_generic_sorter = true;
                override_file_sorter = true;
                case_mode = "smart_case";
              };
            };
          };
        };

        # Theme
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        # Keymaps
        keymaps = [
          {
            key = "<leader>e";
            mode = ["n"];
            action = ":lua MiniFiles.open()<CR>";
            silent = true;
            desc = "Open Mini.Files and manage the filesystem.";
          }
          {
            key = "<C-d>";
            mode = ["n"];
            action = "<C-d>zz";
            silent = true;
          }
          {
            key = "<C-u>";
            mode = ["n"];
            action = "<C-u>zz";
            silent = true;
          }
          {
            key = "<C-f>";
            mode = ["n"];
            action = "<C-f>zz";
            silent = true;
          }
          {
            key = "<C-b>";
            mode = ["n"];
            action = "<C-b>zz";
            silent = true;
          }
        ];

        extraPlugins = with pkgs.vimPlugins; {
          friendly-snippets = {
            package = friendly-snippets;
          };
          telescope-fzf-native = {
            package = telescope-fzf-native-nvim;
            setup = ''
              require('telescope').load_extension('fzf')
            '';
          };
          telescope-ui-select = {
            package = telescope-ui-select-nvim;
            setup = ''
              require('telescope').load_extension('fzf')
            '';
          };
          snacks-nvim = {
            package = snacks-nvim;
            setup = ''
              require('snacks').setup({
                bigfile = {enabled = true},
                quickfile = {enabled = true},
              })
            '';
          };
          helpview-nvim.package = helpview-nvim;
        };
      };
    };
  };
  # Enable custom tmux bar settings
  home.sessionVariables = {
    TINTED_TMUX_OPTION_STATUSBAR = 1;
  };

  # Setup tmux
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    prefix = "C-Space";

    extraConfig = ''
      # start window and panes indexing at 1
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # SPEED
      set-option -g status-interval 1

      # set vi-mode
      set-window-option -g mode-keys vi
      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind "'" split-window -v -c "#{pane_current_path}"
      bind '\' split-window -h -c "#{pane_current_path}"

      # Vim keybindings for pane movement
      setw -g mode-keys vi
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Skip kill pane %Number% (y/n) prompt
      bind-key x kill-pane

      # Don't exit from tmux when closing a session
      set -g detach-on-destroy off

      # Bar to top
      set-option -g status-position top
    '';

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      fzf-tmux-url
    ];
  };
}
