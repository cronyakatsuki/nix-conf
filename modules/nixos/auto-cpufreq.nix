{
  config,
  lib,
  ...
}: {
  options = {
    crony.auto-cpufreq.enable = lib.mkEnableOption "Enable auto-cpufreq and set it up for my laptop.";
  };

  config = lib.mkIf config.crony.auto-cpufreq.enable {
    # Setup auto-cpufreq
    programs.auto-cpufreq = {
      enable = true;

      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };

        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };
}
