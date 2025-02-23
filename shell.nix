{
  pkgs ? import <nixpkgs> {},
  git-hooks,
  ...
}: let
  git-check = git-hooks.lib.${pkgs.system}.run {
    src = ".";
    hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      flake-checker.enable = true;
    };
  };
in
  pkgs.mkShell {inherit (git-check) shellHook;}
