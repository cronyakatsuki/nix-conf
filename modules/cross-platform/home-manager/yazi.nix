{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.yazi.enable = lib.mkEnableOption "Enable and setup yazi file manager.";
  };

  config = lib.mkIf config.crony.yazi.enable {
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
