{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) rnnoise-plugin;
in {
  options = {
    crony.pipewire.enable = lib.mkEnableOption "Setup some config files for my pipewire/wireplumber setup.";
  };

  config = lib.mkIf config.crony.pipewire.enable {
    xdg.configFile."pipewire/pipewire.conf.d/99-rnnoise.conf" = {
      text = builtins.toJSON {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Noise Canceling source";
              "media.name" = "Noise Canceling source";

              "filter.graph" = {
                nodes = [
                  {
                    type = "ladspa";
                    name = "rnnoise";
                    plugin = "${rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                    label = "noise_suppressor_stereo";
                    control = {
                      "VAD Threshold (%)" = 80.0;
                      "VAD Grace Period (ms)" = 200;
                      "Retroactive VAD Grace (ms)" = 0;
                    };
                  }
                ];
              };

              "capture.props" = {
                "node.name" = "capture.rnnoise_source";
                "node.passive" = true;
                "audio.rate" = 48000;
              };

              "playback.props" = {
                "node.name" = "rnnoise_source";
                "media.class" = "Audio/Source";
                "audio.rate" = 48000;
              };
            };
          }
        ];
      };
    };

    xdg.configFile."pipewire/filter-chain.conf.d/sink-eq6.conf" = {
      text = builtins.toJSON {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Equalizer Sink";
              "media.name" = "Equalizer Sink";
              "filter.graph" = {
                nodes = [
                  {
                    type = "builtin";
                    name = "eq_band_1";
                    label = "bq_lowshelf";
                    control = {
                      "Freq" = 100.0;
                      "Q" = 1.0;
                      "Gain" = 1.0;
                    };
                  }
                  {
                    type = "builtin;";
                    name = "eq_band_2";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 100.0;
                      "Q" = 1.0;
                      "Gain" = 3.0;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_3";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 500.0;
                      "Q" = 1.0;
                      "Gain" = 0.0;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_4";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 2000.0;
                      "Q" = 1.0;
                      "Gain" = 0.0;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_5";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 5000.0;
                      "Q" = 1.0;
                      "Gain" = -1.0;
                    };
                  }
                  {
                    type = "builtin";
                    name = "eq_band_6";
                    label = "bq_highshelf";
                    control = {
                      "Freq" = 5000.0;
                      "Q" = 1.0;
                      "Gain" = -2.0;
                    };
                  }
                ];
                links = [
                  {
                    output = "eq_band_1:Out";
                    input = "eq_band_2:In";
                  }
                  {
                    output = "eq_band_2:Out";
                    input = "eq_band_3:In";
                  }
                  {
                    output = "eq_band_3:Out";
                    input = "eq_band_4:In";
                  }
                  {
                    output = "eq_band_4:Out";
                    input = "eq_band_5:In";
                  }
                  {
                    output = "eq_band_5:Out";
                    input = "eq_band_6:In";
                  }
                ];
              };
              "audio.channels" = 2;
              "audio.position" = ["FL" "FR"];
              "capture.props" = {
                "node.name" = "effect_input.eq6";
                "media.class" = "Audio/Sink";
              };
              "playback.props" = {
                "node.name" = "effect_output.eq6";
                "node.passive" = true;
              };
            };
          }
        ];
      };
    };
  };
}
