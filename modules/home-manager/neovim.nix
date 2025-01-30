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
  };
}
