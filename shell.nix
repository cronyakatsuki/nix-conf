{
  pkgs ? import <nixpkgs> {},
  git-hooks,
  inputs,
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
  pkgs.mkShell {
    buildInputs = with pkgs; [
      alejandra
      nixd
      inputs.deploy-rs.packages.${stdenv.hostPlatform.system}.default
    ];

    inherit (git-check) shellHook;
  }
