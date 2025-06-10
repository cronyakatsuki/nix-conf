{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.mpv.enable = lib.mkEnableOption "Enable mpv and customize it to my preference.";
  };

  config = lib.mkIf config.crony.mpv.enable {
    programs.mpv = {
      enable = true;
      config = {
        fs = true;
        force-window = "immediate";
        hr-seek-framedrop = "no";
        profile = "gpu-hq";
        hwdec = "nvdec-copy";
        gpu-api = "vulkan";
        vo = "gpu-next";
        screenshot-format = "png";
        screenshot-high-bit-depth = "yes";
        screenshot-png-compression = "7";
        screenshot-directory = "~/pics/mpv/";
        screenshot-template = "%F - [%P]v%#01n";
        alang = "'jpn,jp,eng,en'";
        sub-file-paths = "Subs;subs";
        sub-auto = "all";
        slang = "english,eng,en,enUS";
        reset-on-next-file = "pause";
        #        no-osd-bar = false;
        osd-duration = "500";
        deband = "yes";
        deband-iterations = "2";
        deband-threshold = "35";
        deband-range = "20";
        deband-grain = "5";
        dither-depth = "auto";
        scale = "ewa_lanczossharp";
        dscale = "mitchell";
        cscale = "spline36";
      };

      scripts = with pkgs.mpvScripts; [
        mpris
        sponsorblock-minimal
        thumbfast
        quality-menu
      ];
    };
  };
}
