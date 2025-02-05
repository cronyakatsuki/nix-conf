{
  config,
  lib,
  ...
}: {
  options = {
    crony.neovim.enable = lib.mkEnableOption "Enable neovim and apply a good config.";
  };

  config = lib.mkIf config.crony.neovim.enable {
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

            css = {
              enable = true;
              format.enable = true;
            };
            ts = {
              enable = true;
              format.enable = true;
            };
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
            statusline.enable = true;
            notify.enable = true;
            indentscope.enable = true;
            hipatterns = {
              enable = true;
              setupOpts = {
                highlighters = {
                  hex_color = lib.generators.mkLuaInline "require('mini.hipatterns').gen_highlighter.hex_color()";
                };
              };
            };
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

          keymaps = [
            {
              key = "<leader>e";
              mode = ["n"];
              action = ":lua MiniFiles.open()<CR>";
              silent = true;
              desc = "Open Mini.Files and manage the filesystem.";
            }
          ];
        };
      };
    };
  };
}
