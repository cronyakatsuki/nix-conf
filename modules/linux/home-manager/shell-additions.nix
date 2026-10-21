{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.shell-additions.enable = lib.mkEnableOption "Enable additional shell software.";
  };

  config = lib.mkIf config.crony.shell-additions.enable {
    home.packages = with pkgs; [
      android-tools
      nurl
      qmk
      dos2unix
      inputs.agenix.packages.${stdenv.hostPlatform.system}.default
      inputs.deploy-rs.packages.${stdenv.hostPlatform.system}.default
      inputs.hb-downloader.packages.${stdenv.hostPlatform.system}.default
      inputs.extract-romset.packages.${stdenv.hostPlatform.system}.default
      inputs.note.packages.${stdenv.hostPlatform.system}.default
      (pkgs.symlinkJoin {
        name = "pi-coding-agent";
        buildInputs = [pkgs.makeWrapper];
        paths = [pkgs.pi-coding-agent];
        postBuild = ''
          wrapProgram $out/bin/pi \
            --set NPM_CONFIG_PREFIX ${config.home.homeDirectory}/.pi/npm/ \
            --prefix PATH : ${
            pkgs.lib.makeBinPath [
              pkgs.nodejs_latest
            ]
          }
        '';
      })
    ];

    programs.beets = {
      enable = false;
      settings = {
        directory = "~/music/to-listen/";
        library = "~/.local/share/beets.db";
        plugins = "fromfilename chroma embedart fetchart duplicates";
        import = {
          move = true;
        };
      };
    };

    # Setup rclone
    programs.rclone = {
      enable = true;
      remotes = {
        homeassistant = {
          config = {
            type = "sftp";
            host = "assistant.home.cronyakatsuki.xyz";
            user = "root";
            key_file = "${config.home.homeDirectory}/.ssh/main";
          };
          mounts = {
            "/var/lib/homeassistant" = {
              enable = true;
              mountPoint = "/home/crony/docs/assistant";
              options = {
                default-permissions = true;
                vfs-cache-mode = "writes";
                buffer-size = "64M";
                multi-thread-streams = 4;
                multi-thread-cutoff = "250M";
              };
            };
          };
        };
      };
    };
  };
}
