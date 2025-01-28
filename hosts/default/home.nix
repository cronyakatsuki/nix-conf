{ config, pkgs, ... }:

{
  # Some info
  home.username = "crony";
  home.homeDirectory = "/home/crony";

  # PACKAGES
  home.packages = with pkgs; [
    librewolf
    thunderbird
    qbittorrent
  ];

  # Enable programs to get their themes
  programs.foot.enable = true;
  programs.mangohud = {
    enable = true;
    settings = {
      fps_limit = "0,30,60,120,144";
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_power = true;
      gpu_text = "GPU";
      gpu_load_change = true;
	
      cpu_stats = true;
      cpu_temps = true;
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

  programs.neovim.enable = true;

  # Enable theming chromium + use ungoogled chromium package
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };

  # Enable git
  programs.git = {
    enable = true;
    userName = "Crony Akatsuki";
    userEmail = "crony@cronyakatsuki.xyz";
  };

  # Default environmental variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Fix gtkrc-2.0 collision
  home.file."/home/crony/.gtkrc-2.0".force = true;

  # DO NOT CHANGE ALSO
  home.stateVersion = "24.11"; # Please read the comment before changing.
}

