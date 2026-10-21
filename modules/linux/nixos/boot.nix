{
  config,
  lib,
  ...
}: {
  options = {
    crony.boot.enable = lib.mkEnableOption "Enable and setup kernel related parameters";
  };

  config = lib.mkIf config.crony.boot.enable {
    boot.consoleLogLevel = 3;
    boot.kernelParams = ["quiet" "udev.log_priority=3"];

    # Splash during early boot. Masks the black-screen gap between TPM2
    # auto-unlock and sddm (see modules/linux/nixos/sddm.nix), and gives the
    # display a clean owner during the nvidia fbcon handoff instead of the
    # stale firmware-logo framebuffer being redrawn as torn strips.
    # The theme itself comes from the stylix plymouth target (autoEnable),
    # which generates a rose-pine-matched splash
    # (modules/linux/nixos/stylix.nix) - don't set boot.plymouth.theme here.
    boot.plymouth.enable = true;
  };
}
