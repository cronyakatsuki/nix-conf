{
  config,
  lib,
  ...
}: {
  options = {
    crony.qutebrowser.enable = lib.mkEnableOption "Install and configure qutebrwoser";
  };

  config = lib.mkIf config.crony.qutebrowser.enable {
    home.file = {
      ".config/qutebrowser/userscripts/buku" = {
        text = ''
          #!/usr/bin/env bash

          # Qutebrowser userscript for interacting with buku
          # requries buku and dmenu (with list patch)

          get_bookmark() {
          	buku --nostdin -p -f5 | sed 's/\t/;/g' | column -t -s ';' | tofi --horizontal false --height 380 --prompt-text "$1 bookmark: " | awk '{ print $1 }'
          }

          get_url() {
          	buku --nostdin -p "$1" -f10
          }

          get_title() {
          	buku --nostdin -p "$1" -f30
          }

          fifo() {
          	printf '%s\n' "$1" >>"$QUTE_FIFO"
          }

          add() {
          	buku --nostdin -a "$QUTE_URL"
          	$TERMINAL --class badd,badd -e buku -w -1
          	fifo "message-info 'Added current url to buku'"
          }

          open() {
          	bookmark=$(get_bookmark "Open")
          	[ -z "$bookmark" ] && fifo "message-info 'No Bookmark selected!!!'" && exit
          	if [ "$1"  == "-t" ]; then
          	  fifo "open -t $(get_url "$bookmark")"
          	  fifo "message-info 'Opening bookmark $(get_title "$bookmark") in new tab.'"
          	else
          	  fifo "open $(get_url "$bookmark")"
          	  fifo "message-info 'Opening bookmark $(get_title "$bookmark").'"
          	fi
          }

          delete() {
          	bookmark=$(get_bookmark "Delete")
          	title=$(get_title "$bookmark")
          	buku --nostdin -d "$bookmark" --tacit
          	fifo "message-info 'Deleted bookmark $title.'"
          }

          edit() {
          	bookmark=$(get_bookmark "Edit")
          	fifo "message-info 'Editing bookmark $(get_title "$bookmark")'"
          	$TERMINAL --class badd,badd -e buku -w "$bookmark"
          }

          main() {
          	case "$1" in
          	"add")
          	  [ -n "$2" ] && QUTE_URL=$2
          		add
          		exit
          		;;
          	"open")
          		open "$2"
          		exit
          		;;
          	"delete")
          		delete
          		exit
          		;;
          	"edit")
          		edit
          		;;
          	esac
          }

          main $@
        '';
        executable = true;
      };
    };

    programs.qutebrowser = {
      enable = true;
      loadAutoconfig = true;
      searchEngines = {
        DEFAULT = "https://searx.cronyakatsuki.xyz/?q={}";
        aw = "https://wiki.archlinux.org/?search={}";
        re = "https://www.reddit.com/r/{}";
        w = "https://en.wikipedia.org/wiki/{}";
        y = "https://www.youtube.com/results?search_query={}";
      };
      settings = {
        colors.webpage = {
          preferred_color_scheme = "dark";
          darkmode.enabled = true;
          bg = "black";
          darkmode.algorithm = "lightness-cielab";
          darkmode.threshold.foreground = 150;
          darkmode.threshold.background = 100;
          darkmode.policy.images = "never";
        };
        content = {
          headers = {
            user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.3";
            accept_language = "en-US,en;q=0.5";
          };

          canvas_reading = false;
          webgl = false;
          webrtc_ip_handling_policy = "default-public-interface-only";
          geolocation = false;
          javascript.enabled = false;
          notifications.enabled = false;
          cookies.accept = "never";
          private_browsing = false;

          blocking.method = "both";
          blocking.adblock.lists = [
            "https://easylist.to/easylist/easylist.txt"
            "https://easylist.to/easylist/easyprivacy.txt"
            "https://secure.fanboy.co.nz/fanboy-annoyance.txt"
            "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
            "https://www.i-dont-care-about-cookies.eu/abp/"
          ];
        };
        completion = {
          web_history.max_items = 0;
          cmd_history_max_items = 0;
        };
      };
      aliases = {
        buku = "spawn --userscript buku";
      };
      keyBindings = {
        normal = {
          ",m" = "spawn mpv {url}";
          ".fm" = "hint links spawn mpv {hint-url}";

          "b" = "buku open";
          "B" = "buku open -t";
          ",ba" = "buku add";
          ",be" = "buku edit";
          ",bd" = "buku delete";
          ",bfa" = "hint links spawn --userscript buku add {hint-url}";

          ",y" = "spawn --userscript yt-dlp";
          ",fy" = "hint links userscript yt-dlp";

          ",fo" = "open {primary}";
          ",fO" = "open --tab {primary}";

          "yf" = "hint links yank";

          "j" = "jseval --quiet scrollHelper.scrollBy(50)";
          "k" = "jseval --quiet scrollHelper.scrollBy(-50)";
          "<Ctrl-D>" = "jseval --quiet scrollHelper.scrollPage(0.8)";
          "<Ctrl-U>" = "jseval --quiet scrollHelper.scrollPage(-0.8)";
          "gg" = "jseval --quiet scrollHelper.scrollTo(0)";
          "G" = "jseval --quiet scrollHelper.scrollToPercent(100)";
        };
        insert = {
          "<Escape>" = "mode-leave ;; jseval -q document.activeElement.blur()";
        };
      };
    };
  };
}
