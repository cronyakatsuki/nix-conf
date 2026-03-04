{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  options = {
    crony.zen-browser.enable = lib.mkEnableOption "Enable and setup zen browser";
  };

  config = lib.mkIf config.crony.zen-browser.enable {
    programs.zen-browser = {
      enable = true;
      suppressXdgMigrationWarning = true;
      profiles = {
        main = {};
      };
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      nativeMessagingHosts = with pkgs; [
        keepassxc
      ];
    };

    stylix.targets.zen-browser.profileNames = ["main"];
  };
}
