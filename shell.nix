{
  pkgs ? import <nixpkgs> {},
  pre-commit-hooks,
  ...
}: let
  pre-commit-check = pre-commit-hooks.lib.${pkgs.system}.run {
    src = ".";
    hooks = {alejandra.enable = true;};
  };
in
  pkgs.mkShell {inherit (pre-commit-check) shellHook;}
