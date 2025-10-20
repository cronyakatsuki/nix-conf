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
      # (retroarch.withCores (
      #   cores:
      #     with cores; [
      #       beetle-saturn
      #       mupen64plus
      #       flycast
      #       desmume
      #     ]
      # ))
      # duckstation
      # pcsx2
      # dolphin-emu
      rpcs3
      # mame-tools
      # steam-rom-manager
      shadps4
    ];
  };
}
