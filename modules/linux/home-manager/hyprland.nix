{
  config,
  inputs,
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

    ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:sys-notify "🔊 Volume: ''${volumep}"
  '';
  toggle-sound-output = pkgs.writeShellScriptBin "toggle-sound-output" ''
    #!/usr/bin/env sh

    speakers="alsa_output.pci-0000_01_00.1.hdmi-stereo"
    headphones="alsa_output.pci-0000_00_1f.3.analog-stereo"

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
      ${pkgs.libnotify}/bin/notify-send "VPN" "UP"
    else
    	nmcli con down hetz
      ${pkgs.libnotify}/bin/notify-send "VPN" "DOWN"
    fi

  '';
  playerctl = "${pkgs.playerctl}/bin/playerctl";
in {
  options = {
    crony.hyprland.enable = lib.mkEnableOption "Enable hyprland and configure it for me";
  };

  config = lib.mkIf config.crony.hyprland.enable {
    # Enable hyprpolkitagent
    services.hyprpolkitagent.enable = true;
    systemd.user.services.hyprpolkitagent.Install.WantedBy = lib.mkForce [];

    # Enable hyprpaper
    services.hyprpaper.enable = true;

    # Disable it by default and have it started manually by hyprland
    systemd.user.services.hyprpaper.Install.WantedBy = lib.mkForce [];

    # Setup portal for hyprland
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    # Enable hypridle
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
          ignore_dbus_inhibit = 1;
          ignore_systemd_inhibit = 1;
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
    # Disable it by default and have it started manually by hyprland
    systemd.user.services.hypridle.Install.WantedBy = lib.mkForce [];

    # Setup and enable hyprland
    wayland.windowManager.hyprland = {
      enable = true;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      systemd.enable = false; # Using USWM globally

      settings = {
        "$mod" = "SUPER";
        "$menu" = "tofi";
        "$terminal" = "kitty";

        env = [
          "LIBVA_DRIVER_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "__GL_GSYNC_ALLOWED,1"
        ];

        exec = [
          # Fix laptop monitor getting turned on while my external monitor connected
          "hyprctl monitors | grep 'HDMI' && hyprctl keyword monitor 'eDP-1, disable'"
          "pkill waybar; waybar" # Kill waybar and start new instance because everytime hyprland restarts breaks waybar
        ];

        cursor = {
          # Breaks mouse in fullscreen
          # no_break_fs_vrr = 1;
          no_hardware_cursors = 1;
          # use_cpu_buffer = 0;
        };

        exec-once = [
          "wl-paste --type text --watch cliphist store" # Stores only text data
          "wl-paste --type image --watch cliphist store" # Stores only image data
          "keepassxc" # Startup my password manager
          "cameractrlsd" # Start service to configure my webcam settings
          "systemctl --user start hyprpolkitagent"
          "systemctl --user start hyprpaper"
          "systemctl --user start hypridle"
        ];

        monitor = [
          "HDMI-A-1, 1920x1080@144, 0x0, 1"
          "DP-1, 1920x1080@165, 0x0, 1"
          "eDP-1, 1920x1080, 0x0, 1"
          "sunshine, 1920x1080@144, 0x0, 1"
        ];

        animations = {
          enabled = false;
        };

        decoration = {
          blur = {
            enabled = false;
          };

          shadow = {
            enabled = false;
          };

          rounding = 0;
        };

        general = {
          border_size = 1;
          gaps_in = 3;
          gaps_out = 6;
          layout = "master";
          allow_tearing = true;
        };

        misc = {
          vrr = 2;
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

          "$mod,        B, exec, zen-beta"
          "$mod SHIFT,  B, exec, librewolf"

          "$mod,        G, exec, ${hyprgamemode}/bin/gamemode"
          "$mod,        F1, exec, ${toggle-sound-output}/bin/toggle-sound-output"
          "$mod SHIFT,  E, exec, ${power-menu}/bin/power-menu"
          "$mod,        w, exec, ${vpn-toggle}/bin/vpn-toggle"

          "$mod,        F12, exec, ${grim} ${config.xdg.userDirs.pictures}/screenshots/$(date +'%s_grim.png')"

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

        windowrule = [
          # Hide xwaylandvideobridge
          "opacity 0.0 override, match:class ^(xwaylandvideobridge)$"
          "no_anim match:class ^(xwaylandvideobridge)$"
          "no_initial_focus match:class ^(xwaylandvideobridge)$"
          "max_size 1 1, match:class ^(xwaylandvideobridge)$"
          "no_blur match:class ^(xwaylandvideobridge)$"
          "no_focus match:class ^(xwaylandvideobridge)$"

          # Disable animations for ueberzugpp
          "no_anim match:class ^(ueberzugpp.*)$"

          # Make workspace 6 a floating layout
          "float match:workspace 6"

          # Make keepassxc floating
          "float match:class ^(org.keepassxc.KeePassXC)$"

          # Move to workspace 1
          "workspace 1, match:class ^(org.qutebrowser.qutebrowser)$"

          # Move to workspace 5
          "workspace 5, match:class ^(vesktop)$"

          # Move to workspace 6
          "workspace 6, match:class ^(steam)$"
          "workspace 6, match:class ^(heroic)$"

          # Enable inhibition for fullscreen apps
          "idle_inhibit fullscreen, match:class ^(*)$"
          "idle_inhibit fullscreen, match:title ^(*)$"
          "idle_inhibit fullscreen, match:fullscreen 1"
        ];
      };
    };
  };
}
