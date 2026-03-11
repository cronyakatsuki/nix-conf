{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.wayland.enable = lib.mkEnableOption "ENable and configure wayland software.";
  };

  config = lib.mkIf config.crony.wayland.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "tofi-pass" ''
        tofi --hide-input true --prompt-text 'Password: ' --require-match false --hidden-character '.' < /dev/null
      '')
      cliphist
      wl-clipboard
      waylock
      inputs.pyprland.packages.${pkgs.stdenv.hostPlatform.system}.pyprland
      hyprshutdown
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # Enable and setup tofi
    programs.tofi = {
      enable = true;
      settings = {
        anchor = "top";
        width = "100%";
        height = "34";
        horizontal = true;
        history = false;
        require-match = false;
        terminal = "foot";
        outline-width = 0;
        border-width = 0;
        min-input-width = 120;
        result-spacing = 15;
        padding-top = 4;
        padding-bottom = 0;
        padding-left = 5;
        padding-right = 5;
      };
    };

    # Install foot
    programs.foot.enable = true;

    # Install kitty
    programs.kitty = {
      enable = true;
    };

    # Setup and enable mako
    services.mako = {
      enable = true;
      settings = {
        on-button-left = "invoke-default-action";
        on-button-middle = "dismiss-group";
        on-button-right = "dismiss";
        on-touch = "invoke-default-action";
        default-timeout = 5000;
        layer = "overlay";
        width = 200;
      };
    };

    # Enable hyprlock
    programs.hyprlock = {
      enable = false;
      package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
      settings = {
        image = {
          path = "$HOME/.face";
          size = 150;
          border_size = 4;
          border_color = "rgb(${config.lib.stylix.colors.base0D})";
          position = "0, 385";
          halign = "center";
          valign = "center";
        };

        background = {
          blur_passes = 4;
        };

        label = [
          {
            text = "$TIME";
            font_size = 90;
            color = "rgb(${config.lib.stylix.colors.base06})";
            position = "0, 245";
            halign = "center";
            valight = "center";
          }
          {
            text = ''cmd[update:43200000] date +"%Y %m %d"'';
            font_size = 25;
            color = "rgb(${config.lib.stylix.colors.base06})";
            position = "0, -225";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    # Disable stylix to add full css, I only need it to add colors
    stylix.targets.waybar.addCss = false;

    programs.wleave = {
      enable = true;
      settings = {
        margin = 200;
        buttons-per-row = "1/1";
        delay-command-ms = 100;
        close-on-lost-focus = true;
        show-keybinds = true;
        buttons = [
          {
            label = "logout";
            action = "hyprshutdown";
            text = "Logout";
            keybind = "e";
            icon = "${pkgs.wleave}/share/wleave/icons/logout.svg";
          }
          {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
            icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
            icon = "${pkgs.wleave}/share/wleave/icons/reboot.svg";
          }
        ];
      };
    };

    # Enable and install waybar
    programs.waybar = {
      enable = true;
      style = ''
        .modules-left {
          padding-left: 10px;
        }

        #workspaces {
          background-color: @base01;
          margin: 0.25em;
          border-radius: 1em;
        }
        #workspaces button {
          padding: 0 0.5em;
          color: @base06;
        }

        #workspaces button.empty {
          color: @base03;
        }

        #workspaces button.visible {
          color: @base06;
        }

        #workspaces button.active {
          color: @base0D;
        }

        #window {
          color: @base0D;
          padding: 0 1em;
        }

        #cpu,
        #memory,
        #temperature,
        #battery,
        #disk,
        #clock {
          color: @base00;
          background-color: @base0D;
          margin: 0.25em;
          border-radius: 0.5em;
          padding: 0 0.5em;
        }

        #tray {
          background-color: @base00;
        }

        .modules-right {
          padding-right: 10px;
        }
      '';
      settings = {
        mainBar = {
          height = 34;
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [
          ];
          modules-right = [
            "cpu"
            "memory"
            "temperature"
            "disk"
            "battery"
            "clock"
            "tray"
          ];
          "hyprland/workspaces" = {
            persistent-workspaces = {
              "*" = [1 2 3 4 5 6 7 8 9];
            };
            format = "{icon}";
            format-icons = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
            };
          };
          disk = {
            path = "/";
            unit = "GB";
            format = "󰋊 {percentage_used}%";
          };
          tray = {
            spacing = 10;
          };
          clock = {
            format = " {:%Y.%m.%d %H:%M}";
          };
          cpu = {
            format = "  {usage}%";
          };
          memory = {
            format = "  {}%";
          };
          temperature = {
            critical-threshold = 80;
            hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon/hwmon1";
            input-filename = "temp2_input";
            format = " {temperatureC}°C";
          };
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };

            format = "{icon} {capacity}%";
            format-full = "{icon} {capacity}%";
            format-charging = " {icon} {capacity}%";
            format-plugged = " {capacity}%";
            format-icons = [" " " " " " " " " "];
          };
        };
      };
    };
  };
}
