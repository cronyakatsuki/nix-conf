{
  config,
  lib,
  ...
}: {
  options = {
    crony.pipewire.enable = lib.mkEnableOption "Enable and setup pipewire with settings.";
  };

  config = lib.mkIf config.crony.pipewire.enable {
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.extraConfig = {
        "51-disable-suspension" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  node.name = "~alsa_input.*";
                }
                {
                  node.name = "~alsa_output.*";
                }
              ];
              actions = {
                update-props = {
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];
          "monitor.bluez.rules" = [
            {
              matches = [
                {
                  node.name = "~alsa_input.*";
                }
                {
                  node.name = "~alsa_output.*";
                }
              ];
              actions = {
                update-props = {
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];
        };
      };
      extraConfig = {
        pipewire."99-silent.bell.conf" = {
          "context.properties" = {
            "modules.x11.bell" = false;
          };
        };
        pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 64;
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 64;
          };
        };
        pipewire-pulse."92-low-latency" = {
          "context.properties" = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = {};
            }
          ];
          "pulse.properties" = {
            "pulse.min.req" = "64/48000";
            "pulse.default.req" = "64/48000";
            "pulse.max.req" = "64/48000";
            "pulse.min.quantum" = "64/48000";
            "pulse.max.quantum" = "64/48000";
          };
          "stream.properties" = {
            "node.latency" = "64/48000";
            "resample.quality" = 1;
          };
        };
      };
    };

    # Fix not saving my state
    hardware.alsa.enablePersistence = true;
  };
}
