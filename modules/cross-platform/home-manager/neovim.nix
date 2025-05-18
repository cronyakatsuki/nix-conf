{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  markdown-table-mode = pkgs.vimUtils.buildVimPlugin {
    name = "markdown-table-mode";
    src = pkgs.fetchFromGitHub {
      owner = "Kicamon";
      repo = "markdown-table-mode.nvim";
      rev = "fe207ea7cef615ccaf2c0f1257c58ffa0a50a9f5";
      hash = "sha256-JGc5L+7/eSBww1HaMl0AVcIwEJF/RFqoVRpR3DnP6+E=";
    };
  };
in {
  options = {
    crony.neovim.enable = lib.mkEnableOption "Enable neovim and apply a good config.";
  };

  config = lib.mkIf config.crony.neovim.enable {
    # Disable stylix for nvf, I wan't to use a properly implemented theme sorry.
    stylix.targets.nvf.enable = false;

    # Setup neovim
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          # Use the nighly package
          package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
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
            formatOnSave = false;
            inlayHints.enable = true;
            lightbulb.enable = true;
            lspSignature.enable = true;
            lspkind.enable = true;
            lspsaga.enable = true;
            otter-nvim.enable = true;
            trouble.enable = true;
          };

          # Enable diagnostics
          diagnostics = {
            enable = true;
            nvim-lint = {
              enable = true;
            };
          };

          # Enable formatting with conform-nvim
          formatter = {
            conform-nvim = {
              enable = true;
            };
          };

          # Some git related stuff
          git = {
            git-conflict = {
              enable = true;
            };
            gitlinker-nvim = {
              enable = true;
            };
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
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

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
            nix = {
              enable = true;
              lsp = {
                server = "nixd";
                options = {
                  nixos = {
                    expr = ''(builtins.getFlake "/home/crony/repos/nixos").nixosConfigurations.CONFIGNAME.options'';
                  };
                  home_manager = {
                    expr = ''(builtins.getFlake "/home/crony/repos/nixos").homeConfigurations.CONFIGNAME.options'';
                  };
                };
              };
            };
            bash.enable = true;
            go = {
              enable = true;

              format = {
                enable = true;
                type = "gofumpt";
              };
            };
            markdown = {
              enable = true;
              extensions.render-markdown-nvim.enable = true;
            };
            html.enable = true;
          };

          # utility related plugins
          utility = {
            direnv = {
              enable = true;
            };
            icon-picker = {
              enable = true;
            };
            snacks-nvim = {
              enable = true;
              setupOpts = {
                bigfile = {enabled = true;};
                quickfile = {enabled = true;};
              };
            };
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
            sessions.enable = true;
            visits.enable = true;
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
            starter.enable = true;
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

          navigation.harpoon.enable = true;

          extraLuaFiles = [./nvim/autocommands.lua];

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
            markdown-table-mode-nvim = {
              package = markdown-table-mode;
              setup = ''
                require('markdown-table-mode').setup()
              '';
            };
            helpview-nvim.package = helpview-nvim;
          };
        };
      };
    };
  };
}
