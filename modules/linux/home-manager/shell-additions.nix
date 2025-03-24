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
    ];
  };
}
