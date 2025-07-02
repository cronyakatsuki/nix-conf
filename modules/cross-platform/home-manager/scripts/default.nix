{pkgs, ...}:
with pkgs;
  stdenv.mkDerivation {
    pname = "scripts";
    version = "1";
    src = ./bin;

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/bin

      # move scripts to bin
      mv ./* $out/bin

      # Fix shebangs for scripts
      patchShebangs $out/bin

      # Add dependencies to the runtime for my cue2chd script
      wrapProgram $out/bin/cue2chd \
        --prefix PATH : ${lib.makeBinPath [mame-tools]}

      # Add dependencies to the runtime for my iso2chd script
      wrapProgram $out/bin/iso2chd \
        --prefix PATH : ${lib.makeBinPath [mame-tools]}

      # Add dependencies for optimise-vid script
      wrapProgram $out/bin/optimise-vid \
        --prefix PATH : ${lib.makeBinPath [ffmpeg cudatoolkit]}
    '';
  }
