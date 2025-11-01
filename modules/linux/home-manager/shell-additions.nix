{
  inputs,
  config,
  home,
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
      nix-output-monitor
      nvd
      nurl
      # termsonic
      # inputs.iamb.packages.x86_64-linux.default
      inputs.agenix.packages.${system}.default
      inputs.deploy-rs.packages.${system}.default
      inputs.hb-downloader.packages.${system}.default
      inputs.note.packages.${system}.default
      beets
      croc
    ];

    programs.rclone = {
      enable = true;
      remotes = {
        homeassistant = {
          config = {
            type = "sftp";
            host = "assistant.home.cronyakatsuki.xyz";
            user = "root";
            key_file = "${home.homeDirectory} ~/.ssh/main";
          };
          mounts = {
            "/var/lib/homeassistant" = {
              enable = true;
              mountPoint = "/home/crony/docs/assistant";
              options = {
                default-premissions = true;
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
