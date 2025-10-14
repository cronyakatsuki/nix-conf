{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    crony.emacs.enable = lib.mkEnableOption "Enable and setup emacs";
  };

  config = lib.mkIf config.crony.emacs.enable {
    # Disable emacs stylix target
    stylix.targets.emacs.enable = false;

    # Setup emacs
    programs.emacs = {
      enable = true;
      package = pkgs.emacsWithPackagesFromUsePackage {
        package = pkgs.emacs-git;
        config = ./configs/emacs/config.org;
        extraEmacsPackages = epkgs: [
          epkgs.use-package
        ];
        defaultInitFile = true;
        alwaysEnsure = true;
        alwaysTangle = true;
      };
    };
  };
}
