{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options.crony.pico8 = with lib; {
    enable = mkEnableOption "Enable pico-8 and install from inputs.pico-8-src";
  };

  config = lib.mkIf config.crony.pico8.enable {
    home.packages = let
      pico-8-files = pkgs.stdenv.mkDerivation {
        name = "pico-8-files";
        src = inputs.pico-8;
        nativeBuildInputs = with pkgs; [unzip];
        unpackCmd = "unzip $curSrc";
        installPhase = ''
          mkdir -p $out
          cp ./pico8 ./pico8.dat ./lexaloffle-pico8.png $out
        '';
      };
      pico-8-bin-wrapped = pkgs.buildFHSEnv {
        name = "pico-8";
        targetPkgs = pkgs: (with pkgs; [
          libX11
          libXext
          libXcursor
          libXinerama
          libXi
          libXrandr
          libXScrnSaver
          libXxf86vm
          libxcb
          libXrender
          libXfixes
          libXau
          libXdmcp
          alsa-lib
          udev
          wget
        ]);
        runScript = ''bash -c "${pico-8-files}/pico8"'';
      };
      pico8DesktopItem = pkgs.makeDesktopItem {
        name = "pico-8";
        desktopName = "PICO-8";
        exec = "${pico-8-bin-wrapped}/bin/pico-8";
        icon = "${pico-8-files}/lexaloffle-pico8.png";
      };
    in [pico-8-bin-wrapped pico8DesktopItem];
  };
}
