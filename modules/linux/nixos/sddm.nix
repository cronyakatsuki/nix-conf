{
  config,
  pkgs,
  lib,
  ...
}: let
  theme = pkgs.sddm-astronaut;
in {
  options = {
    crony.sddm.enable = lib.mkEnableOption "Enable sddm.";
  };

  config = lib.mkIf config.crony.sddm.enable {
    environment.systemPackages = [
      theme
    ];
    services.displayManager.sddm = {
      enable = true;
      extraPackages = [theme];
      wayland = {
        enable = true;
        # KWin handles late input hotplug and the DRM-master handoff to the
        # next session cleanly; weston (the default) both aborts on zero
        # input devices at startup and leaves a stale fbcon snapshot that
        # gets torn-replayed on handoff. This is also what the greeter ran
        # on from 2026-03 to 2026-05 with no issues of either kind.
        compositor = "kwin";
      };
      theme = "sddm-astronaut-theme";
    };

    # TPM2 auto-unlock removed the passphrase wait, so sddm now starts a few
    # seconds after boot - before udev/libinput has tagged the input devices -
    # and the weston kiosk greeter aborts ("failed to create input devices")
    # leaving tty1 without a GUI. Same issue Ubuntu fixed in sddm
    # 0.20.0-2ubuntu4.2 by ordering the unit after systemd-udev-settle
    # (launchpad bug #2063143); the keyboard wait below additionally covers
    # paired wireless receivers (Logitech DJ) that register slightly later.
    systemd.services.display-manager = {
      after = ["systemd-udev-settle.service"];
      wants = ["systemd-udev-settle.service"];
      serviceConfig.ExecStartPre = let
        wait-for-input = pkgs.writeShellScript "sddm-wait-for-input" ''
          for _ in $(seq 1 60); do
            if udevadm info --export-db | grep -q "ID_INPUT_KEYBOARD"; then
              exit 0
            fi
            sleep 0.5
          done
        '';
      in ["+${wait-for-input}"];
    };
  };
}
