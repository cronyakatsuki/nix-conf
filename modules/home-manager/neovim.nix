{
  config,
  pkgs,
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

            lua.enable = true;
            # python = {
            #   enable = true;
            #   format.type = "black-and-isort";
            # };
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
              lsp = {
                server = "nixd";
                options = {
                  nixos = {
                    expr = ''(builtins.getFlake "/home/crony/Repos/nixos").nixosConfigurations.CONFIGNAME.options'';
                  };
                  home_manager = {
                    expr = ''(builtins.getFlake "/home/crony/Repos/nixos").homeConfigurations.CONFIGNAME.options'';
                  };
                };
              };
            };
            bash.enable = true;
            go.enable = true;
            markdown = {
              enable = true;
              extensions.render-markdown-nvim.enable = true;
            };
          };

          # Setup snippet support
          snippets.luasnip.enable = true;

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
                  hex_color = lib.generators.mkLuaInline "require('mini.hipatterns').gen_highlighter.hex_color()";
                };
              };
            };
            icons.enable = true;
            indentscope.enable = true;
            notify.enable = true;
            starter.enable = true;
            statusline.enable = true;
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

          extraPlugins = with pkgs.vimPlugins; {
            harpoon = {
              package = harpoon2;
              setup = ''
                local harpoon = require("harpoon")

                -- REQUIRED
                harpoon:setup()
                -- REQUIRED

                vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
                vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

                vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
                vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
                vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
                vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
              '';
            };
          };
        };
      };
    };
  };
}
