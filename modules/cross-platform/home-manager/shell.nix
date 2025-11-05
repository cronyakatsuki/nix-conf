{
  config,
  pkgs,
  lib,
  ...
}: {
  # Module that bundles all my shell related software that make up my shell experience
  options = {
    crony.shell.enable = lib.mkEnableOption "Enable my bundled shell software that make up my shell experience";
  };

  config = lib.mkIf config.crony.shell.enable {
    home.packages = with pkgs; [
      age
      ffmpeg
      imagemagick
      buku
      unzip
      p7zip
      aria2
      just
    ];

    # Enable nix-index
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    # Enable comma
    programs.nix-index-database.comma.enable = true;

    # Enable git
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Crony Akatsuki";
          email = "crony@cronyakatsuki.xyz";
        };
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

    home.sessionVariables = {
      _ZO_EXCLUDE_DIRS = "$HOME:$HOME/docs/share:/mnt";
    };

    # Install eza
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "always";
      extraOptions = [
        "--group-directories-first"
      ];
    };

    # Install direnv
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    # Install tealdeer
    programs.tealdeer.enable = true;

    # Install bat
    programs.bat.enable = true;

    # Install jq
    programs.jq.enable = true;

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

    # Install lazygit
    programs.lazygit.enable = true;

    # Install and setup gpg
    programs.gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.local/share/gnupg";
    };
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentry = {
        package = pkgs.pinentry-gtk2;
        program = "pinentry-gtk-2";
      };
    };

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
        filter_mode = "directory";
      };
    };

    # Install and setup yazi
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
      settings = {
        mgr = {
          ratio = [0 4 4];
          sort_by = "natural";
          show_hidden = true;
          show_symlink = false;
        };
      };
      plugins = {
        full-border = pkgs.yaziPlugins.full-border;
        smart-enter = pkgs.yaziPlugins.smart-enter;
        smart-tab = ./yazi/smart-tab;
        folder-rules = ./yazi/folder-rules;
      };
      initLua = ''
        require("full-border"):setup({
          type = ui.Border.ROUNDED,
        })

        require("smart-enter"):setup({
          open_multi = true,
        })

        require("folder-rules"):setup()
      '';
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "t";
            run = "plugin smart-tab";
            desc = "Create a tab and enter the howered directory";
          }
        ];
      };
    };
  };
}
