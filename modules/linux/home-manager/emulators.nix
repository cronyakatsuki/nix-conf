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
            flycast
            genesis-plus-gx
            gambatte
            mgba
            mupen64plus
            fbneo
            mesen
            beetle-ngp
            beetle-pce
            beetle-saturn
            snes9x
            desmume
            swanstation
          ]
      ))
      pcsx2
      dolphin-emu
      rpcs3
      xemu
      xenia-canary
      cemu
      # mame-tools
      # steam-rom-manager
      # shadps4 # flatpak version just works
    ];
  };
}
