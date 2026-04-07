{
  config,
  lib,
  ...
}: {
  options = {
    crony.pc-services.enable = lib.mkEnableOption "Enable and setup pc related service for gpu/fan/rgb management.";
  };

  config = lib.mkIf config.crony.pc-services.enable {
    # Enable coolercontrol to setup fancurves
    programs.coolercontrol = {
      enable = true;
    };

    # Setup gpu fan curves and light undervolt
    services.lact = {
      enable = true;
    };

    environment.etc."lact/config.yaml".text = ''
      apply_settings_timer: 5
      auto_switch_profiles: false
      current_profile: null
      daemon:
        admin_group: wheel
        disable_clocks_cleanup: false
        log_level: info
      gpus:
        10DE:2D04-1771:205E-0000:01:00.0:
          fan_control_enabled: true
          fan_control_settings:
            change_threshold: 2
            curve:
              40: 0.3
              50: 0.5
              54: 0.7
              57: 0.85
              60: 1.0
            interval_ms: 500
            mode: curve
            spindown_delay_ms: 5000
            static_speed: 0.5
            temperature_key: edge
          gpu_clock_offsets:
            0: 275
          max_core_clock: 2900
          min_core_clock: 180
      version: 5
    '';

    # Setup display brightness changing using ddcutil
    hardware.i2c.enable = true;

    # Setup rgb control
    services.hardware.openrgb.enable = true;

    # Needed modules to have fan control
    boot.kernelModules = ["coretemp" "nct6775"];
  };
}
