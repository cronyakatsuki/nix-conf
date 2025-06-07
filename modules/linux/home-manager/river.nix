{
  config,
  pkgs,
  lib,
  ...
}: let
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
in {
  options = {
    crony.river.enable = lib.mkEnableOption "Enable and setup river window manager";
  };

  config = lib.mkIf config.crony.river.enable {
    home.packages = with pkgs; [
      playerctl
      grim
      libnotify
      wlopm
    ];

    services.way-displays = {
      enable = true;
      settings = {
        SCALING = false;
        DISABLED = [
          {
            NAME_DESC = "eDP-1";
            IF = [
              {
                PLUGGED = [
                  "HDMI-A-1"
                ];
              }
            ];
          }
        ];
      };
    };

    wayland.windowManager.river = {
      enable = true;
      settings = {
        set-repeat = "50 300";
        default-layout = "rivertile";
        keyboard-layout = {
          "-options" = {
            "'caps:escape,grp:alt_space_toggle'" = "'us,hr'";
          };
        };
        rule-add = {
          "-app-id" = {
            "'bar'" = "csd";
            "'steam'" = "ssd";
            "'librewolf'" = "ssd";
            "'float*'" = {
              "-title" = {
                "foo" = "float";
              };
            };
          };
        };
        map = {
          normal = {
            "Super Return" = "spawn foot";
            "Super+Shift Q" = "close";
            "Super+Control E" = "exit";
            "Super Tab" = "focus-previous-tags";
            "Super J" = "focus-view next";
            "Super K" = "focus-view previous";
            "Super+Shift J" = "swap next";
            "Super+Shift K" = "swap previous";
            "Super+Shift Return" = "zoom";
            "Super H" = "send-layout-cmd rivertile 'main-ratio -0.05'";
            "Super L" = "send-layout-cmd rivertile 'main-ratio +0.05'";
            "Super+Shift ." = "send-layout-cmd rivertile 'main-count +1'";
            "Super+Shift ," = "send-layout-cmd rivertile 'main-count -1'";
            "Super+Shift Space" = "toggle-float";
            "Super F" = "toggle-fullscreen";
            "Super D" = "spawn 'tofi-run | xargs riverctl spawn'";
            "Super+Shift D" = "spawn 'tofi-drun | xargs riverctl spawn'";
            "Super+Shift L" = "spawn 'hyprlock --immediate'";
            "Super B" = "spawn qutebrowser";
            "Super+Shift B" = "spawn librewolf";
            "Super F1" = "spawn '${toggle-sound-output}/bin/toggle-sound-output'";
            "Super+Shift E" = "spawn '${power-menu}/bin/power-menu'";
            "Super F12" = "spawn 'grim ${config.xdg.userDirs.pictures}/screenshots/$(date +%s_grim.png)'";
            "Super V" = "spawn 'cliphist list | tofi --horizontal false --height 380 | cliphist decode | wl-copy'";
          };
        };
        map-pointer = {
          normal = {
            "Super BTN_LEFT" = "move-view";
            "Super BTN_RIGHT" = "resize-view";
            "Super BTN_MIDDLE" = "toggle-float";
          };
        };
        spawn = [
          "waybar" # Start waybar on start
          "wl-paste --type text --watch cliphist store" # Stores only text data
          "wl-paste --type image --watch cliphist store" # Stores only image data
          "keepassxc" # Startup my password manager
        ];
      };
      systemd = {
        enable = true;
      };
      xwayland.enable = true;
      extraConfig = ''
        for i in $(seq 1 9)
        do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
        done

        for mode in normal locked
        do
            riverctl map $mode None XF86AudioRaiseVolume  spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1 && ${volume-notify}/bin/volume-notify'
            riverctl map $mode None XF86AudioLowerVolume  spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1 && ${volume-notify}/bin/volume-notify'
            riverctl map $mode None XF86AudioMute         spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ${volume-notify}/bin/volume-notify'

            riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
            riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
            riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
            riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

            riverctl map $mode None XF86MonBrightnessUp   spawn 'light -A 10'
            riverctl map $mode None XF86MonBrightnessDown spawn 'light -D 10'
        done


        rivertile -view-padding 6 -outer-padding 6 -main-ratio 0.5 &
      '';
    };
  };
}
