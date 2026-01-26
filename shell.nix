{
  pkgs ? import <nixpkgs> {},
  git-hooks,
  ...
}: let
  git-check = git-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run {
    src = ".";
    hooks = {
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
