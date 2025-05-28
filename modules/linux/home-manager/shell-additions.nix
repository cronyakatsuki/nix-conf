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
      nix-output-monitor
      nvd
      nurl
      termsonic
      inputs.iamb.packages.x86_64-linux.default
      toot
      inputs.agenix.packages.${system}.default
      inputs.deploy-rs.packages.${system}.default
      inputs.hb-downloader.packages.${system}.default
    ];
  };
}
