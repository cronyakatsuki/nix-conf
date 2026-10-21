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
      unzip
      p7zip
      aria2
      just
      trash-cli
      gptfdisk
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

    # Install fastfetch
    programs.fastfetch = {
      enable = true;
      settings = {
        display = {
          separator = "  ";
        };
        modules = [
          {
            type = "os";
            key = " OS";
            keyColor = "yellow";
          }
          {
            type = "kernel";
            key = "│ ├";
            keyColor = "yellow";
          }
          {
            type = "packages";
            key = "│ ├󰏖";
            keyColor = "yellow";
          }
          {
            type = "shell";
            key = "│ └";
            keyColor = "yellow";
          }
          {
            type = "wm";
            key = " wm";
            keyColor = "blue";
          }
          {
            type = "lm";
            key = "│ ├󰧨";
            keyColor = "blue";
          }
          {
            type = "terminal";
            key = "│ └";
            keyColor = "blue";
          }
          {
            type = "host";
            key = " HOST";
            keyColor = "green";
          }
          {
            type = "cpu";
            key = "│ ├";
            keyColor = "green";
          }
          {
            type = "gpu";
            key = "│ ├󰍛";
            keyColor = "green";
          }
          {
            type = "disk";
            key = "│ ├";
            keyColor = "green";
          }
          {
            type = "memory";
            key = "│ ├󰑭";
            keyColor = "green";
          }
          {
            type = "swap";
            key = "│ ├󰓡";
            keyColor = "green";
          }
          {
            type = "uptime";
            key = "│ ├󰅐";
            keyColor = "green";
          }
          {
            type = "display";
            key = "│ └󰍹";
            keyColor = "green";
          }
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
      extraOptions = [
        "--group-directories-first"
        "--group"
      ];
    };

    # Install direnv
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    # Install tealdeer
    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };

    # Install bat
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batman
      ];
    };

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

    # Install htop
    programs.htop.enable = true;

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
        package = pkgs.pinentry-gnome3;
        program = "pinentry-gnome3";
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
  };
}
