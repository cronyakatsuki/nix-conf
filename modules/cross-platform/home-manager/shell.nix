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
        plugin = {
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
          prepend_previewers = [
            # Archive previewer
            {
              mime = "application/*zip";
              run = "ouch";
            }
            {
              mime = "application/x-tar";
              run = "ouch";
            }
            {
              mime = "application/x-bzip2";
              run = "ouch";
            }
            {
              mime = "application/x-7z-compressed";
              run = "ouch";
            }
            {
              mime = "application/x-rar";
              run = "ouch";
            }
            {
              mime = "application/vnd.rar";
              run = "ouch";
            }
            {
              mime = "application/x-xz";
              run = "ouch";
            }
            {
              mime = "application/xz";
              run = "ouch";
            }
            {
              mime = "application/x-zstd";
              run = "ouch";
            }
            {
              mime = "application/zstd";
              run = "ouch";
            }
            {
              mime = "application/java-archive";
              run = "ouch";
            }
          ];
          opener = {
            extract = [
              {
                run = "ouch -d -y \"$@\"";
                desc = "Extract here with ouch";
              }
            ];
          };
        };
      };
      plugins = {
        full-border = pkgs.yaziPlugins.full-border;
        smart-enter = pkgs.yaziPlugins.smart-enter;
        smart-tab = ./yazi/smart-tab;
        folder-rules = ./yazi/folder-rules;
        toggle-pane = pkgs.yaziPlugins.toggle-pane;
        parent-arrow = ./yazi/parent-arrow;
        chmod = pkgs.yaziPlugins.chmod;
        ouch = pkgs.yaziPlugins.ouch;
        git = pkgs.yaziPlugins.git;
        mount = pkgs.yaziPlugins.mount;
      };
      initLua = ./yazi/init.lua;
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
          {
            on = "<C-w>";
            for = "linux";
            run = "shell -- hyprctl hyprpaper reload , \"$0\"";
            desc = "Set howered file as wallpaper";
          }
          {
            on = [" " "p"];
            run = "plugin toggle-pane min-preview";
            desc = "Show or hide the preview pane";
          }
          {
            on = "K";
            run = "plugin parent-arrow -1";
          }
          {
            on = "J";
            run = "plugin parent-arrow 1";
          }
          {
            on = ["g" "r"];
            run = "shell -- ya emit cd \"$(git rev-parse --show-toplevel)\"";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = "C";
            run = "plugin ouch tar.gz";
            desc = "Compress with ouch";
          }
          {
            on = "M";
            run = "plugin mount";
            desc = "Manage mounting disks";
          }
        ];
      };
    };
  };
}
