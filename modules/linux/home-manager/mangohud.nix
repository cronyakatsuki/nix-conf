{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.mangohud.enable = lib.mkEnableOption "Enable mangohud and customize it";
  };

  config = lib.mkIf config.crony.mangohud.enable {
    # Setup nice view for mangohud
    programs.mangohud = {
      enable = true;
      package = pkgs.mangohud_git;
      settings = {
        fps_limit = "0,30,60,120,144";
        gpu_stats = true;
        gpu_temp = true;
        gpu_core_clock = true;
        gpu_power = true;
        gpu_text = "GPU";
        gpu_load_change = true;

        cpu_stats = true;
        cpu_temp = true;
        cpu_text = "CPU";
        cpu_mhz = true;
        cpu_load_change = true;

        vram = true;
        ram = true;

        fps = true;
        fps_sampling_period = "1000";
        fps_color_change = true;
        gpu_name = true;
        vulka_driver = true;
        round_corder = "10";
        offset_x = "10";
        offset_y = "10";

        width = "250";
      };
    };
  };
}
