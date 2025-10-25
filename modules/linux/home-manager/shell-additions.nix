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
  };
}
