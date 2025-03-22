{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.emulators.enable = lib.mkEnableOption "Install my emulators";
  };

  config = lib.mkIf config.crony.emulators.enable {
    home.packages = with pkgs; [
      (retroarch.withCores (
        cores:
          with cores; [
            beetle-saturn
            mupen64plus
            flycast
            desmume
          ]
      ))
      duckstation
      pcsx2
      dolphin-emu
      xemu
      rpcs3
      cemu
      ppsspp-sdl-wayland
      mame-tools
    ];
  };
}
