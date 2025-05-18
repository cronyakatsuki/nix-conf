{
  config,
  pkgs,
  lib,
  ...
}: let
  hyprgamemode = pkgs.writeShellScriptBin "gamemode" ''
    #!/usr/bin/env sh
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:shadow:enabled 0;\
            keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
        exit
    fi
    hyprctl reload
    hyprctl monitors | grep 'HDMI' && hyprctl keyword monitor "eDP-1, disable"
  '';
  volume-notify = pkgs.writeShellScriptBin "volume-notify" ''
    #!/usr/bin/env sh

    volumep="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

    case "$volumep" in
    *0.0*) volumep="''${volumep##* 0.0}%" ;;
    *0.*) volumep="''${volumep##* 0.}%" ;;
    *MUTED*) volumep='MUTED' ;;
    *) volumep="100%" ;;
    esac

    notify-send -h string:x-canonical-private-synchronous:sys-notify "🔊 Volume: ''${volumep}"
  '';
  toggle-sound-output = pkgs.writeShellScriptBin "toggle-sound-output" ''
    #!/usr/bin/env sh

    speakers="alsa_output.pci-0000_05_00.1.hdmi-stereo"
    headphones="alsa_output.usb-Xtrfy_SC1_Xtrfy_SC1-00.analog-stereo"

    current="$(wpctl status -n | grep Audio/Sink | grep -oE '[^ ]+$')"

    if [ "''${current}" = "''${headphones}" ]; then
    	wpctl set-default "$(pw-cli info $speakers | head -n 1 | awk '{print $2}')"
    else
    	wpctl set-default "$(pw-cli info $headphones | head -n 1 | awk '{print $2}')"
    fi

  '';
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    #!/usr/bin/env sh

    case "$(printf "shutdown\\nreboot" | tofi --prompt "Choose your poison")" in
    "shutdown") poweroff ;;
    "reboot") reboot ;;
    esac
  '';
  grim = "${pkgs.grim}/bin/grim";
  vpn-toggle = pkgs.writeShellScriptBin "vpn-toggle" ''
    #!/usr/bin/env sh

    if [ "$(nmcli --overview -f GENERAL.STATE connection show hetz)" = "" ]; then
    	nmcli con up hetz
      notify-send "VPN" "UP"
    else
    	nmcli con down hetz
      notify-send "VPN" "DOWN"
    fi

  '';
  playerctl = "${pkgs.playerctl}/bin/playerctl";
in {
  options = {
    crony.hyprland.enable = lib.mkEnableOption "Enable hyprland and configure it for me";
  };

  config = lib.mkIf config.crony.hyprland.enable {
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

    # Enable hyprpaper
    services.hyprpaper.enable = true;

    # Enable hypridle
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 10; # 10 sec
            on-timeout = "pidof hyprlock && hyprctl dispatch dpms off"; # Turn off screen if hyprlock is running
            on-resume = "hyprctl dispatch dpms on"; # Turn on screen when activiy is detected after timeout has fired
          }
          {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 310; # 5min and 10 sec
            on-timeout = "hyprctl dispatch dpms off"; # Turn off screen if hyprlock is running
            on-resume = "hyprctl dispatch dpms on"; # Turn on screen when activiy is detected after timeout has fired
          }
        ];
      };
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

    # Setup and enable hyprland
    wayland.windowManager.hyprland = {
      enable = true;

      systemd.enable = false; # Using USWM globally

      settings = {
        "$mod" = "SUPER";
        "$menu" = "tofi";
        "$terminal" = "foot";

        exec = [
          # Fix laptop monitor getting turned on while my external monitor connected
          "hyprctl monitors | grep 'HDMI' && hyprctl keyword monitor 'eDP-1, disable'"
        ];

        exec-once = [
          "wl-paste --type text --watch cliphist store" # Stores only text data
          "wl-paste --type image --watch cliphist store" # Stores only image data
          "keepassxc" # Startup my password manager
          "waybar" # Start waybar on start
        ];

        monitor = [
          "HDMI-A-1, 1920x1080@144, 0x0, 1"
        ];

        animations = {
          enabled = "yes";
        };

        decoration = {
          blur = {
            enabled = true;
          };

          shadow = {
            enabled = true;
          };

          rounding = 10;
        };

        general = {
          border_size = 3;
          gaps_in = 5;
          gaps_out = 10;
          layout = "master";
          allow_tearing = true;
        };

        misc = {
          vrr = 1;
        };

        input = {
          kb_layout = "us,hr";
          kb_options = "caps:escape,grp:alt_space_toggle";
          accel_profile = "flat";
        };

        master = {
          mfact = "0.5";
          new_status = "slave";
        };

        binds = {
          allow_workspace_cycles = true;
        };

        bind = [
          "$mod,        Return, exec, $terminal"
          "$mod SHIFT,  Q, killactive"
          "$mod CTRL,   E, exit"
          "$mod SHIFT,  Space, togglefloating"
          "$mod,        D, exec, tofi-run | xargs hyprctl dispatch exec --"
          "$mod SHIFT,  D, exec, tofi-drun | xargs hyprctl dispatch exec --"

          "$mod,        F, fullscreen"

          "$mod SHIFT,  L, exec, hyprlock --immediate"

          "$mod,        B, exec, chromium"
          "$mod SHIFT,  B, exec, librewolf"

          "$mod,        G, exec, ${hyprgamemode}/bin/gamemode"
          "$mod,        F1, exec, ${toggle-sound-output}/bin/toggle-sound-output"
          "$mod SHIFT,  E, exec, ${power-menu}/bin/power-menu"
          "$mod,        w, exec, ${vpn-toggle}/bin/vpn-toggle"

          "$mod,        F12, exec, ${grim} $HOME/Pictures/screenshots/$(date +'%s_grim.png')"

          "$mod,        V, exec, cliphist list | tofi --horizontal false --height 380 | cliphist decode | wl-copy"

          "$mod,        j, layoutmsg, cyclenext"
          "$mod,        k, layoutmsg, cycleprev"
          "$mod SHIFT,  j, layoutmsg, swapnext"
          "$mod SHIFT,  k, layoutmsg, swapprev"

          "$mod,        h, layoutmsg, mfact -0.05"
          "$mod,        l, layoutmsg, mfact +0.05"

          "$mod,        Tab, workspace, previous"

          "$mod,        1, workspace, 1"
          "$mod,        2, workspace, 2"
          "$mod,        3, workspace, 3"
          "$mod,        4, workspace, 4"
          "$mod,        5, workspace, 5"
          "$mod,        6, workspace, 6"
          "$mod,        7, workspace, 7"
          "$mod,        8, workspace, 8"
          "$mod,        9, workspace, 9"

          "$mod SHIFT,  1, movetoworkspacesilent, 1"
          "$mod SHIFT,  2, movetoworkspacesilent, 2"
          "$mod SHIFT,  3, movetoworkspacesilent, 3"
          "$mod SHIFT,  4, movetoworkspacesilent, 4"
          "$mod SHIFT,  5, movetoworkspacesilent, 5"
          "$mod SHIFT,  6, movetoworkspacesilent, 6"
          "$mod SHIFT,  7, movetoworkspacesilent, 7"
          "$mod SHIFT,  8, movetoworkspacesilent, 8"
          "$mod SHIFT,  9, movetoworkspacesilent, 9"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1 && ${volume-notify}/bin/volume-notify"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1 && ${volume-notify}/bin/volume-notify"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ${volume-notify}/bin/volume-notify"
        ];

        # Requires playerctl
        bindl = [
          ", XF86AudioPlay, exec, ${playerctl} play-pause"
          ", XF86AudioPrev, exec, ${playerctl} previous"
          ", XF86AudioNext, exec, ${playerctl} next"

          '', switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, 1920x1080, 0x0, 1"''
          '', switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"''
        ];

        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod ALT, mouse:272, resizewindow"
        ];

        windowrulev2 = [
          # Hide xwaylandvideobridge
          "opacity 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"
          "nofocus, class:^(xwaylandvideobridge)$"

          # Disable animations for ueberzugpp
          "noanim, class:^(ueberzugpp.*)$"

          # Allow tearing for sifu
          "immediate, class:^(steam_app_2138710)$"
          "immediate, class:^(steam_app_1145360)$"
          "immediate, class:^(Graveyard Keeper.x86_64)$"
          "immediate, class:^(gamescope)$"
          "immediate, class:^(steam_app_1087760)$"

          # Make workspace 6 a floating layout
          "float, workspace:6"

          # Make keepassxc floating
          "float, class:^(org.keepassxc.KeePassXC)$"

          # Move to workspace 5
          "workspace 5, class:^(vesktop)$"

          # Enable inhibition for fullscreen apps
          "idleinhibit fullscreen, class:^(*)$"
          "idleinhibit fullscreen, title:^(*)$"
          "idleinhibit fullscreen, fullscreen:1"
        ];
      };
    };
  };
}
