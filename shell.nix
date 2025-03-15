{
  pkgs ? import <nixpkgs> {},
  git-hooks,
  ...
}: let
  git-check = git-hooks.lib.${pkgs.system}.run {
    src = ".";
    hooks = {
      # General formaters
      end-of-file-fixer.enable = true;
      mixed-line-endings.enable = true;
      # Git commit lint
      commitizen.enable = true;
      # Nix section
      alejandra.enable = true;
      # deadnix.enable = true;
      flake-checker.enable = true;
    };
  };
in
  pkgs.mkShell {inherit (git-check) shellHook;}
