{
  config,
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

    # Setup and enable mako
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
        layer = "overlay";
        width = 200;
      };
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 10;
          command = "pidof hyprlock && ${pkgs.wlopm}/bin/wlopm --off '*'";
          resumeCommand = "${pkgs.wlopm}/bin/wlopm --on '*'";
        }
      ];
    };

    # Enable hyprlock
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = false;
        };

        image = {
          path = "$HOME/.face";
          size = 150;
          border_size = 4;
          border_color = "rgb(d5c4a1)";
          position = "0, 385";
          halign = "center";
          valign = "center";
        };

        label = [
          {
            text = "$TIME";
            font_size = 90;
            color = "rgb(d5c4a1)";
            position = "0, 245";
            halign = "center";
            valight = "center";
          }
          {
            text = ''cmd[update:43200000] date +"%Y %m %d"'';
            font_size = 25;
            color = "rgb(d5c4a1)";
            position = "0, -225";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    # Disable stylix to add full css, I only need it to add colors
    stylix.targets.waybar.addCss = false;

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
            hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
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

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      # config = {
      #   common = {
      #     default = [
      #       "gtk"
      #     ];
      #   };
      # };
    };
  };
}
